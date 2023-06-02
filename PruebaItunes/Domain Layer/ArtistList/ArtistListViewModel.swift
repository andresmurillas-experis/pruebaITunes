//
//  ArtistListPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/3/23.
//

import Foundation
import Combine

final class ArtistListViewModel {
    private var appDependencies: AppDependenciesResolver
    private var cancellables = [AnyCancellable]()
    var subject: CurrentValueSubject<[ArtistEntity], WebAPIDataSource.NetworkError>
    private var artistList: [ArtistEntity] = [] {
        didSet {
            subject.send(artistList)
        }
    }
    private var albumList: [String?]?
    init(appDependencies: AppDependenciesResolver) {
        subject = CurrentValueSubject(artistList)
        self.appDependencies = appDependencies
    }
}

private extension ArtistListViewModel {
    var coordinator: ArtistListCoordinator {
        appDependencies.resolve()
    }
}

extension ArtistListViewModel {
    func renewSearch(for searchText: String) {
        let artistName = searchText.replacingOccurrences(of: " ", with: "+")
        artistList = []
        let getArtists: GetArtists = appDependencies.resolve()
        getArtists.execute(artistName: artistName).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                print("GetArtists finished succesfully")
            case .failure(let error):
                print(error)
                print("Encountered error in GetArtists")
            }
        }, receiveValue: { [weak self] (result) in
            let artistListNoAlbums = result.results.map {
                let id = $0.artistId
                let name = $0.artistName
                return ArtistEntity(id: id, name: name)
            }
            self?.addDiscsToArtistsIn(artistListNoAlbums)
        }).store(in: &cancellables)
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        coordinator.goToDetailViewForArtist(artist)
    }
}

private extension ArtistListViewModel {
    func addDiscsToArtistsIn(_ artistListNoAlbums: [ArtistEntity?]) {
        let getTwoAlbumNames: GetTwoAlbumNamesUseCase = appDependencies.resolve()
        artistListNoAlbums.forEach { artistNoAlbums in
            getTwoAlbumNames.execute(albumId: artistNoAlbums?.id ?? 0).sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("GetTwoAlbumNames finished succesfully")
                    case .failure:
                        print("Encountered error in GetTwoAlbums")
                        self?.subject.send(completion: .failure(WebAPIDataSource.NetworkError.alamofire))
                    }
                }, receiveValue: { [weak self] iTunesAlbums in
                    let albumList = iTunesAlbums.results.map {
                        let name = $0.collectionName
                        let cover = $0.artworkUrl60
                        let coverLarge = $0.artworkUrl100
                        return AlbumEntity(albumName: name, albumCover: cover, albumCoverLarge: coverLarge)
                    }
                    var safeAlbumList: [AlbumEntity] = []
                    for i in 1...2 {
                        if i <= albumList.count - 1{
                            safeAlbumList.append(albumList[i])
                        } else {
                            safeAlbumList.append(AlbumEntity(albumName: nil, albumCover: nil, albumCoverLarge: nil))
                        }
                    }
                    self?.artistList.append(ArtistEntity(id: artistNoAlbums?.id ?? 0, name: artistNoAlbums?.name ?? "", discOneName: safeAlbumList[0].albumName, discTwoName: safeAlbumList[1].albumName))
                }).store(in: &cancellables)
        }
    }
}
