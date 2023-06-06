//
//  ArtistDetailPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation
import Combine

final class ArtistDetailViewModel {
    private var appDependencies: AppDependenciesResolver
    var subject: CurrentValueSubject<[AlbumEntity], WebAPIDataSource.NetworkError>
    private var cancellables = [AnyCancellable]()
    private var artist: ArtistEntity?
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        self.subject = CurrentValueSubject([])
    }
}

extension ArtistDetailViewModel {
    func setArtist(_ artist: ArtistEntity) {
        self.artist = artist
    }
    func viewDidLoad() {
        guard let artistId = artist?.id else {
            return
        }
        let getAlbums: GetAlbums = appDependencies.resolve()
        getAlbums.execute(albumId: artistId).sink(receiveCompletion: { [weak self] (completion) in
            switch completion {
            case .finished:
                print("GetAlbums finished succesfully")
            case .failure:
                print("Encountered error")
                self?.subject.send(completion: .failure(WebAPIDataSource.NetworkError.alamofire))
            }
        }, receiveValue: { [weak self] (iTunesAlbumList) in
            var iTunesAlbumListResults = iTunesAlbumList.results
            iTunesAlbumListResults.removeFirst()
            let albumList = iTunesAlbumListResults.map {
                let albumName = $0.collectionName
                let cover = $0.artworkUrl60
                let coverLarge = $0.artworkUrl100
                return AlbumEntity(albumName: albumName, albumCover: cover, albumCoverLarge: coverLarge)
            }
            self?.subject.send(albumList)
        }).store(in: &cancellables)
    }
}
