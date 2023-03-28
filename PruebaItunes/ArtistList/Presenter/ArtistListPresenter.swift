//
//  ArtistListPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/3/23.
//

import Foundation

protocol ArtistListPresenterProtocol: AnyObject {
    var artistListView: ArtistListViewController? { get set }
    var appDependencies: AppDependenciesResolver? { get set }
    func viewDidLoad()
    func goTo(_ view: ArtistDetailViewController)  
}

final class ArtistListPresenter  {
    private var dataTask: URLSessionDataTask?
    weak var artistListView: ArtistListViewController?
    var appDependencies: AppDependenciesResolver?
}

extension ArtistListPresenter{
    func goTo(_ view: ArtistDetailViewController) {
        view.setAppDependencies(appDependencies)
        guard let coordinator: Coordinator = appDependencies?.resolve() else {
            return
        }
        coordinator.goTo(view)
    }
}

extension ArtistListPresenter: ArtistListPresenterProtocol {
    func viewDidLoad() {
        guard let client: DownloadClient = appDependencies?.resolve() else {
            return
        }
        client.download(from: "https://itunes.apple.com/search?term=metallica&entity=musicArtist&attribute=artistTerm") { [weak self] (result: Result<ITunesArtistModel, DownloadClient.NetworkError>) in
            switch result {
            case .success(let iTunesArtistModel):
                let artistList = iTunesArtistModel.results.map { ArtistViewModel(id: $0.artistId, name: $0.artistName) }
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
}
