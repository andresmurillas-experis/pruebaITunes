//
//  ArtistDetailPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation

final class ArtistDetailViewModel {
    private var artist: ArtistEntity?
    private var appDependencies: AppDependenciesResolver
    var albumListBinding: Bindable<[AlbumEntity]> = Bindable([])
    init(appDependencies: AppDependenciesResolver) {
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
        getAlbums.execute(albumId: artistId) { albumList in
            self.albumListBinding.value = albumList
        }
    }
}
