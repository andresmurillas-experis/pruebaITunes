//
//  ArtistDetailPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation

final class ArtistDetailViewModel {
    private var dataTask: URLSessionDataTask?
    private var artist: ArtistEntity?
    private let downloadClient: WebAPIDataSource
    private var appDependencies: AppDependenciesResolver
    var albumListBinding: Bindable<[AlbumEntity]> = Bindable([])
    var albumDataSource: AlbumDataSource
    init(appDependencies: AppDependenciesResolver) {
        self.downloadClient = appDependencies.resolve()
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
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
        albumDataSource.getAllAlbumsFor(artistId: artistId) { [weak self] (result: Result<AlbumDTO, WebAPIDataSource.NetworkError>) in
            switch result {
            case .success(let iTunesAlbumModel):
                let albumList: [AlbumEntity] = iTunesAlbumModel.results.compactMap {
                    if $0.collectionName == nil {
                        return nil
                    }
                    return AlbumEntity(albumName: $0.collectionName, albumCover: $0.artworkUrl60, albumCoverLarge: $0.artworkUrl100)
                }
                self?.albumListBinding.value = albumList
                return
            case .failure(let error):
                switch error {
                case .serviceError:
                    print("No Data Eroor: ", error)
                case .noData:
                    print("Network Service Error: ", error)
                case .parsing:
                    print("JSON Parsing Error: ", error)
                }
            }
        }
    }
}
