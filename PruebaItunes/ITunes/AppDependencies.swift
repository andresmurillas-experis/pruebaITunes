//
//  AppDependencies.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/3/23.
//

import UIKit
import Foundation

protocol AppDependenciesResolver {
    func getNavigator() -> UINavigationController
}

extension AppDependenciesResolver {
    func resolve() -> DownloadClient {
        DownloadClient()
    }
    func resolve() -> ArtistListPresenterProtocol {
        ArtistListPresenter(appDependencies: self)
    }
    func resolve() -> ArtistDetailPresenterProtocol {
        ArtistDetailPresenter(appDependencies: self)
    }
    func resolve() -> ArtistListViewProtocol {
        ArtistListViewController(nibName: "ArtistListViewController", bundle: nil, presenter: resolve())
    }
    func resolve() -> Coordinator {
        Coordinator(self, navigationController: getNavigator())
    }
}

final class AppDependencies {
    private let navigator: UINavigationController
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
}

extension AppDependencies: AppDependenciesResolver {
    func getNavigator() -> UINavigationController {
        navigator
    }
}

struct Coordinator {
    private var navigationController: UINavigationController
    private var appDependencies: AppDependenciesResolver
    init(_ appDependencies : AppDependenciesResolver, navigationController: UINavigationController) {
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
