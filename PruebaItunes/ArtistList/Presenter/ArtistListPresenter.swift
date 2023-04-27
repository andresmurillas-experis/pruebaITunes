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

final class ArtistListPresenter  {
    private var dataTask: URLSessionDataTask?
    weak var artistListView: ArtistListViewController?
    private var appDependencies: AppDependenciesResolver
    private var downloadClient: DownloadClient
    private var newArtistList: [ArtistModel] = [ArtistModel(id: 0, name: "")]
    private var artistListNoDiscs: [ArtistModel] = [ArtistModel(id: 0, name: "")] {
        didSet {
            addDiscsToArtistIn(artistListNoDiscs)
        }
    }
    private var artistList: [ArtistModel] = [ArtistModel(id: 0, name: "ko")] {
        didSet {
            self.artistListView?.setArtistList(artistList)
        }
    }
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
        guard let artistQuery = artistListView?.searchText.replacingOccurrences(of: " ", with: "+") else {
            return
        }
        downloadClient.download(from: "https://itunes.apple.com/search?term=\(artistQuery)&entity=musicArtist&attribute=artistTerm") { [weak self] (result: Result<ITunesArtistModel, DownloadClient.NetworkError>) in
            switch result {
            case .success(let iTunesArtistModel):
                self?.artistListNoDiscs = iTunesArtistModel.results.map {
                    let id = $0.artistId
                    let name = $0.artistName
                    return ArtistModel(id: id, name: name)
                }
            case .failure(let error):
                switch error {
                case .serviceError:
                    print(error)
                    print("No Data Eroor: ", error)
                case .noData:
                    print(error)
                    print("Network Service Error: ", error)
                case .parsing:
                    print(error)
                    print("JSON Parsing Error: ", error)
                }
            }
        }
    }
    func goToDetailViewForArtist(_ artist: ArtistModel) {
        coordinator.goToDetailViewForArtist(artist)
    }
}

private extension ArtistListPresenter {
    func addDiscsToArtistIn(_ artistListNoDiscs: [ArtistModel]) {
        artistList = []
        artistListNoDiscs.map { artist in
            albumList = ["", ""]
            self.downloadClient.download(from: "https://itunes.apple.com/lookup?id=\(artist.id)&entity=album&limit=2") { [weak self] (result: Result<ITunesAlbumModel, DownloadClient.NetworkError>) in
                switch result {
                case .success(let iTunesAlbumModel):
                    if (iTunesAlbumModel.results.count > 1) {
                        self?.artistList.append(self?.createArtist(artist: artist, disc1: iTunesAlbumModel.results[1].collectionName, disc2: iTunesAlbumModel.results.last?.collectionName) ?? ArtistModel(id: 0, name: ""))
                    } else {
                        self?.artistList.append(self?.createArtist(artist: artist, disc1: iTunesAlbumModel.results.first?.collectionName, disc2: iTunesAlbumModel.results.last?.collectionName) ?? ArtistModel(id: 0, name: ""))
                    }
                case .failure(let error):
                    print(result)
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
    func createArtist(artist: ArtistModel, disc1: String?, disc2: String?) -> ArtistModel {
        var artist = artist
        artist.setDiscNames(discOneName: disc1, discTwoName: disc2)
        return artist
        
    }
}
