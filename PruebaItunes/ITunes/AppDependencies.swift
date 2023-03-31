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
    func resolve() -> ArtistListViewController
    func resolve() -> ArtistListPresenter
    func resolve() -> ArtistDetailPresenter
}

final class AppDependencies {
    private let navigator: UINavigationController
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
}

struct Coordinator {
    private var navigationController: UINavigationController
    var appDependencies: AppDependencies
    init(_ appDependencies : AppDependencies, navigationController: UINavigationController) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    func goToDetailViewForArtist(_ artist: ArtistViewModel) {
        let presenter: ArtistDetailPresenter = appDependencies.resolve()
        presenter.setArtist(artist)
        let artistDetailView: ArtistDetailViewController = ArtistDetailViewController(nibName: "ArtistDetailViewController", bundle: nil, presenter: presenter)
        navigationController.pushViewController(artistDetailView, animated: true)
    }
    func getInitialViewController() -> UIViewController {
        let presenter: ArtistListPresenter = appDependencies.resolve()
        let artistListView = ArtistListViewController(nibName: "ArtistListViewController", bundle: nil, presenter: presenter)
        return artistListView
    }
}

extension AppDependencies: AppDependenciesResolver {
    func resolve() -> DownloadClient {
        return DownloadClient()
    }
    func resolve() -> Coordinator {
        return Coordinator(self, navigationController: navigator)
    }
    func resolve() -> ArtistListViewController {
        let presenter: ArtistListPresenter = resolve()
        let artistListView = ArtistListViewController(nibName: "ArtistListViewController", bundle: nil, presenter: presenter)
        return artistListView
    }
    func resolve() -> ArtistListPresenter {
        let artistListPresenter = ArtistListPresenter(appDependencies: self)
        return artistListPresenter
    }
    func resolve() -> ArtistDetailPresenter {
        let artistDetailPresenter = ArtistDetailPresenter(appDependencies: self)
        return artistDetailPresenter
    }
}
