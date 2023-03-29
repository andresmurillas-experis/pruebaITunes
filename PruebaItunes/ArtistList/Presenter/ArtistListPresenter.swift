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
    func goToDetailViewForArtist(_ artist: ArtistViewModel)
}

final class ArtistListPresenter  {
    private var dataTask: URLSessionDataTask?
    weak var artistListView: ArtistListViewController?
    private var appDependencies: AppDependenciesResolver
    init(dataTask: URLSessionDataTask? = nil, artistListView: ArtistListViewController? = nil, appDependencies: AppDependenciesResolver) {
        self.dataTask = dataTask
        self.artistListView = artistListView
        self.appDependencies = appDependencies
    }
}

extension ArtistListPresenter{
    func goToDetailViewForArtist(_ artist: ArtistViewModel) {
        let presenter: ArtistDetailPresenter = appDependencies.resolve()
        let coordinator: Coordinator = appDependencies.resolve()
        presenter.setArtist(artist)
        coordinator.goToDetailViewWithPresenter(presenter)
    }
}

extension ArtistListPresenter: ArtistListPresenterProtocol {
    func viewDidLoad() {
        let client: DownloadClient = appDependencies.resolve()
        client.download(from: "https://itunes.apple.com/search?term=jony&cash&entity=musicArtist&attribute=artistTerm") { [weak self] (result: Result<ITunesArtistModel, DownloadClient.NetworkError>) in
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
