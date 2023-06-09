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
    private var passSub = PassthroughSubject<Int, Never>()
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
        getAlbums
            .execute(albumId: artistId).subscribe(on: DispatchQueue.global(qos: .background)).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    print("GetAlbums finished succesfully")
                case .failure:
                    print("Encountered error")
                    return
                }
            }, receiveValue: { [weak self] (albums) in
                var albumList: [AlbumEntity] = albums
                albumList.removeFirst()
                self?.subject.send(albumList)
            }).store(in: &cancellables)
    }
}

private extension ArtistDetailViewModel {
    func bindSubjects() {
        self.passSub.flatMap { [unowned self] albumId in
            let getalbums : GetAlbums = appDependencies.resolve()
            return getalbums.execute(albumId: albumId)
        }.sink { completion in
            if case .failure = completion {
                self.bindSubjects()
            }
        } receiveValue: { albums in
            self.subject.send(albums)
        }.store(in: &cancellables)
    }
}
