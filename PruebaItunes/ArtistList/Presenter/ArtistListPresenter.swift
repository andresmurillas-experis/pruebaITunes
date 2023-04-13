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
        print(artistQuery)
        downloadClient.download(from: "https://itunes.apple.com/search?term=\(artistQuery)&entity=musicArtist&attribute=artistTerm") { [weak self] (result: Result<ITunesArtistModel, DownloadClient.NetworkError>) in
            switch result {
            case .success(let iTunesArtistModel):
                let artistList = iTunesArtistModel.results.map { ArtistModel(id: $0.artistId, name: $0.artistName) }
                self?.artistListView?.setArtistList(artistList)
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
    func goToDetailViewForArtist(_ artist: ArtistModel) {
        coordinator.goToDetailViewForArtist(artist)
    }
}
