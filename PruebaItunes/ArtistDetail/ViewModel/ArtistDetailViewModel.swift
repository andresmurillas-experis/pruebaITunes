//
//  ArtistDetailPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation

final class ArtistDetailViewModel {
    private var dataTask: URLSessionDataTask?
    private var artist: ArtistViewModel?
    private let downloadClient: DownloadClient
    private var appDependencies: AppDependenciesResolver

    var albumListBinding: Bindable<[AlbumViewModel]> = Bindable() { _ in }

    init(appDependencies: AppDependenciesResolver) {
        self.downloadClient = appDependencies.resolve()
        self.appDependencies = appDependencies
    }
}

extension ArtistDetailViewModel {
    func setArtist(_ artist: ArtistViewModel) {
        self.artist = artist
    }
    func viewDidLoad() {
        guard let artistId = artist?.id else {
            return
        }
        downloadClient.download(from: "https://itunes.apple.com/lookup?id=\(artistId)&entity=album") { [weak self] (result: Result<ITunesAlbumModel, DownloadClient.NetworkError>) in
            switch result {
            case .success(let iTunesAlbumModel):
                let albumList: [AlbumViewModel] = iTunesAlbumModel.results.compactMap {
                    if $0.collectionName == nil {
                        return nil
                    }
                    return AlbumViewModel(albumName: $0.collectionName, albumCover: $0.artworkUrl60, albumCoverLarge: $0.artworkUrl100)
                }
                self?.albumListBinding.bind(albumList)
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
