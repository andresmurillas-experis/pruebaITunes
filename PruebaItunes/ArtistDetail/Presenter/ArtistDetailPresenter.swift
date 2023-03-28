//
//  ArtistDetailPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation

protocol ArtistDetailPresenterProtocol: AnyObject {
    var artistDetailView: ArtistDetailViewController? { get set }
    var appDependencies: AppDependenciesResolver? { get set }
    func setArtist(_ artist: ArtistViewModel)
    func viewDidLoad()
}

final class ArtistDetailPresenter {
    weak var artistDetailView: ArtistDetailViewController?
    private var dataTask: URLSessionDataTask?
    private var artist: ArtistViewModel?
    var appDependencies: AppDependenciesResolver?
}

extension ArtistDetailPresenter: ArtistDetailPresenterProtocol {

    func setArtist(_ artist: ArtistViewModel) {
        self.artist = artist
    }

    func viewDidLoad() {
        guard let artistId = artist?.id else {
            return
        }
        guard let client: DownloadClient = appDependencies?.resolve() else {
            return
        }
        client.download(from: "https://itunes.apple.com/lookup?id=\(artistId)&entity=album") { [weak self] (result: Result<ITunesAlbumModel, DownloadClient.NetworkError>) in
            switch result {
            case .success(let iTunesAlbumModel):
                let albumList: [AlbumViewModel] = iTunesAlbumModel.results.compactMap {
                    if $0.collectionName == nil {
                        return nil
                    }
                    return AlbumViewModel(albumName: $0.collectionName, albumCover: $0.artworkUrl60, albumCoverLarge: $0.artworkUrl100)
                }
                self?.artistDetailView?.setAlbumList(albumList)
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
