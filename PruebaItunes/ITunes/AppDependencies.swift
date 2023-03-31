//
//  AppDependencies.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/3/23.
//

import UIKit
import Foundation

protocol AppDependenciesResolver {
    func resolve() -> DownloadClient
    func resolve() -> Coordinator
    func resolve() -> ArtistListViewProtocol
    func resolve() -> ArtistListPresenterProtocol
    func resolve() -> ArtistDetailPresenterProtocol
}

final class AppDependencies {
    private let navigator: UINavigationController
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
}

extension AppDependencies: AppDependenciesResolver {
    func resolve() -> DownloadClient {
        DownloadClient()
    }
    func resolve() -> Coordinator {
        Coordinator(self, navigationController: navigator)
    }
    func resolve() -> ArtistListPresenterProtocol {
        ArtistListPresenter(appDependencies: self)
    }   
    func resolve() -> ArtistDetailPresenterProtocol {
        ArtistDetailPresenter(appDependencies: self)
    }
    func resolve() -> ArtistListViewProtocol {
        let presenter: ArtistListPresenterProtocol = resolve()
        let artistListView = ArtistListViewController(nibName: "ArtistListViewController", bundle: nil, presenter: presenter)
        return artistListView
    }
}

struct Coordinator {
    private var navigationController: UINavigationController
    private var appDependencies: AppDependencies
    init(_ appDependencies : AppDependencies, navigationController: UINavigationController) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    func goToDetailViewForArtist(_ artist: ArtistViewModel) {
        let presenter: ArtistDetailPresenterProtocol = appDependencies.resolve()
        presenter.setArtist(artist)
        let artistDetailView = ArtistDetailViewController(nibName: "ArtistDetailViewController", bundle: nil, presenter: presenter)
        navigationController.pushViewController(artistDetailView, animated: true)
    }
    func getInitialViewController() -> UIViewController {
        let presenter: ArtistListPresenterProtocol = appDependencies.resolve()
        let artistListView = ArtistListViewController(nibName: "ArtistListViewController", bundle: nil, presenter: presenter)
        return artistListView
    }
}

