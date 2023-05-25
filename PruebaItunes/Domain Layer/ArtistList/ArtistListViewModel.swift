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
    var artistSubject: CurrentValueSubject<[ArtistEntity], Error>
    var networkErrorSubject: CurrentValueSubject<WebAPIDataSource.NetworkError?, Error>
    private var artistList: [ArtistEntity] = [] {
        didSet {
            artistSubject.send(artistList)
        }
    }
    private var albumList: [String?]?
    init(appDependencies: AppDependenciesResolver) {
        artistSubject = CurrentValueSubject(artistList)
        networkErrorSubject = CurrentValueSubject(nil)
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
        getArtists.execute(artistName: artistName) { [self] (artistList, error)  in
            guard let artistNoDiscs = artistList else {
                networkErrorSubject.send(error)
                return
            }
            self.addDiscsToArtistsIn(artistNoDiscs)
        }
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        coordinator.goToDetailViewForArtist(artist)
    }
}

private extension ArtistListViewModel {
    func addDiscsToArtistsIn(_ artistListNoAlbums: [ArtistEntity]) {
        let getTwoAlbumNames: GetTwoAlbumNamesUseCase = appDependencies.resolve()
        artistListNoAlbums.forEach { artistNoAlbums in
            var albums: [AlbumEntity] = []
            getTwoAlbumNames.execute(albumId: artistNoAlbums.id) { (twoAlbums) in
                albums = twoAlbums
                let artist = ArtistEntity(id: artistNoAlbums.id, name: artistNoAlbums.name, discOneName: albums[0].albumName,
                                            discTwoName: albums[1].albumName)
                self.artistList.append(artist)
            }
        }
    }
}
