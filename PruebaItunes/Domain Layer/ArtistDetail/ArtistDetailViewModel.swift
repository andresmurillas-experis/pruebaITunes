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
    var albumSubject: CurrentValueSubject<[AlbumEntity]?, Error>
    var networkErrorSubject: CurrentValueSubject<WebAPIDataSource.NetworkError?, Error>
    private var artist: ArtistEntity?
    init(appDependencies: AppDependenciesResolver) {
        albumSubject = CurrentValueSubject(nil)
        networkErrorSubject = CurrentValueSubject(nil)
        self.appDependencies = appDependencies
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
        getAlbums.execute(albumId: artistId) { albumList, error in
            guard let albumList = albumList else {
                self.networkErrorSubject.send(error)
                return
            }
            self.albumSubject.send(albumList)
        }
    }
}
