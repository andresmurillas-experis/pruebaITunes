//
//  ArtistListPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/3/23.
//

import Foundation

protocol ArtistListPresenterProtocol: AnyObject {
    var artistListView: ArtistListViewController? { get set }
    func viewDidLoad()
    func goToDetailViewForArtist(_ artist: ArtistModel)
}

struct ITunesAlbums {
    var artist: ArtistModel?
    var disc1: String?
    var disc2: String?
}

final class ArtistListPresenter  {
    private var dataTask: URLSessionDataTask?
    weak var artistListView: ArtistListViewController?
    private var appDependencies: AppDependenciesResolver
    private var downloadClient: DownloadClient
    private var iTunesAlbums: [ITunesAlbums?] = [] {
        didSet {
            artistList = insertCoversInto(artistList ?? [])
        }
    }
    private var artistList: [ArtistModel]?
    private var albumList: [String?]?
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        downloadClient = appDependencies.resolve()
    }
}

private extension ArtistListPresenter {
    var coordinator: Coordinator {
        appDependencies.resolve()
    }
}

extension ArtistListPresenter: ArtistListPresenterProtocol {
    func viewDidLoad() {
        guard let artistQuery = artistListView?.searchText.replacingOccurrences(of: " ", with: "%20") else {
            return
        }
        var albumList = [nil, nil, nil] as [AlbumModel?]
        var artistList: [ArtistModel]?
        downloadClient.download(from: "https://itunes.apple.com/search?term=\(artistQuery)&entity=musicArtist&attribute=artistTerm") { [weak self] (result: Result<ITunesArtistModel, DownloadClient.NetworkError>) in
            switch result {
            case .success(let iTunesArtistModel):
                artistList = iTunesArtistModel.results.map {
                    let id = $0.artistId
                    let name = $0.artistName
                    return ArtistModel(id: id, name: name)
                }
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
            self?.artistListView?.setArtistList(artistList)
        }
    }
    func goToDetailViewForArtist(_ artist: ArtistModel) {
        coordinator.goToDetailViewForArtist(artist)
    }
    
    func insertCoversInto(_ artistList: [ArtistModel]) -> [ArtistModel] {
        var newArtist: [ArtistModel] =  iTunesAlbums.map { album in
            var artist = album?.artist
            var disc1 = album?.disc1
            var disc2 = album?.disc2
            artist?.setDiscNames(discOneName: disc1, discTwoName: disc2)
            return artist ?? ArtistModel(id: 0, name: "")
        }
        return newArtist
    }
    
    func getAlbumCoversFor(_ artist: ArtistModel) {
        downloadClient.download(from: "https://itunes.apple.com/lookup?id=\(artist.id)&entity=album&limit=2") { [weak self] (result: Result<ITunesAlbumModel, DownloadClient.NetworkError>) in
            switch result {
            case .success(let iTunesAlbumModel):
                var discNames: [String?] = [nil, nil]
                var albums: [ITunesAlbums] = []
                discNames = iTunesAlbumModel.results.compactMap {
                    if $0.collectionName == nil {
                        return nil
                    }
                    return $0.collectionName
                }
                albums.append(ITunesAlbums(artist: artist, disc1: discNames[0], disc2: discNames[1]))
                self?.iTunesAlbums = albums
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
