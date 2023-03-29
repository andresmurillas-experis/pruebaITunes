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
    var appDependencies: AppDependenciesResolver?
}

extension ArtistListPresenter{

    func goToDetailViewForArtist(_ artist: ArtistViewModel) {
        guard let coordinator: Coordinator = appDependencies?.resolve() else {
            return
        }
        guard let detailView: ArtistDetailViewController = appDependencies?.resolve() else {
            return
        }
        guard let presenter: ArtistDetailPresenter = appDependencies?.resolve() else {
            return
        }
        presenter.setArtist(artist)
        detailView.setPresenter(presenter)
        coordinator.goTo(detailView)
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
                print("SUCCES")
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