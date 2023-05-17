//
//  ArtistListPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/3/23.
//

import Foundation

protocol ArtistListPresenterProtocol: AnyObject {
    var artistListView: ArtistListViewController? { get set }
    func renewSearch()
    func goToDetailViewForArtist(_ artist: ArtistEntity)
}

final class ArtistListPresenter  {
    weak var artistListView: ArtistListViewController?
    private var appDependencies: AppDependenciesResolver
    private var artistList: [ArtistEntity] = [] {
        didSet {
            self.artistListView?.setArtistList(artistList)
        }
    }
    private var albumList: [String?]?
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
}

private extension ArtistListPresenter {
    var coordinator: Coordinator {
        appDependencies.resolve()
    }
}

extension ArtistListPresenter: ArtistListPresenterProtocol {
    func renewSearch() {
        guard let artistName = artistListView?.searchText.replacingOccurrences(of: " ", with: "+") else {
            return
        }
        artistList = []
        let getArtists: GetArtists = appDependencies.resolve()
        getArtists.execute(artistName: artistName) { artistList in
            let artistNoDiscs = artistList
            self.addDiscsToArtistsIn(artistNoDiscs)
        }
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        coordinator.goToDetailViewForArtist(artist)
    }
}

private extension ArtistListPresenter {
        func addDiscsToArtistsIn(_ artistListNoAlbums: [ArtistEntity]) {
            let getTwoAlbumNames: GetTwoAlbumNamesUseCase = appDependencies.resolve()
            artistListNoAlbums.forEach { artistNoAlbums in
                var albums: [AlbumEntity] = []
                    getTwoAlbumNames.execute(albumId: artistNoAlbums.id) { twoAlbums in
                    albums = twoAlbums
                    let artist = ArtistEntity(id: artistNoAlbums.id, name: artistNoAlbums.name, discOneName: albums[0].albumName, discTwoName: albums[1].albumName)
                    self.artistList.append(artist)
                }
            }
        }
}
