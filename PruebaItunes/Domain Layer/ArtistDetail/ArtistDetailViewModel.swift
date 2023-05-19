//
//  ArtistDetailPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation

final class ArtistDetailViewModel {
    private var artist: ArtistEntity?
    private var appDependencies: AppDependencies
    var albumListBinding: Bindable<[AlbumEntity]> = Bindable([])
    var errorBinding: Bindable<WebAPIDataSource.NetworkError> = Bindable(nil)
    init(appDependencies: AppDependencies) {
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
                guard let error = error else  {
                     return
                }
                self.errorBinding.value = error
                return
            }
            self.albumListBinding.value = albumList
        }
    }
}
