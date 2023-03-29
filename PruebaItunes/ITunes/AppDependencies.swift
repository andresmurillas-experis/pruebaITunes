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
    func resolve() -> ArtistDetailViewController
    func resolve() -> ArtistListPresenter
    func resolve() -> ArtistDetailPresenter
}

final class AppDependencies: AppDependenciesResolver {
    private var navigator: UINavigationController?
    func setNavigationController(_ navigator: UINavigationController) {
        self.navigator = navigator
    }
    func resolve() -> DownloadClient {
        return DownloadClient()
    }
    func resolve() -> Coordinator {
        return Coordinator(self, navigationController: navigator)
    }
    func resolve() -> ArtistListViewController {
        let artistListView = ArtistListViewController(nibName: "ArtistListViewController", bundle: nil)
        return artistListView
    }
    func resolve() -> ArtistDetailViewController {
        let artistDetailView = ArtistDetailViewController(nibName: "ArtistDetailViewController", bundle: nil)
        return artistDetailView
    }
    func resolve() -> ArtistListPresenter {
        let artistListPresenter = ArtistListPresenter(appDependencies: self)
        artistListPresenter.appDependencies = self
        return artistListPresenter
    }
    func resolve() -> ArtistDetailPresenter {
        let artistDetailPresenter = ArtistDetailPresenter(appDependencies: self)
        artistDetailPresenter.appDependencies = self
        return artistDetailPresenter
    }
}

struct Coordinator {
    private var navigationController: UINavigationController?
    weak var appDependencies: AppDependencies?
    init(_ appDependencies : AppDependencies, navigationController: UINavigationController?) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    func goTo(_ artistDetailView: ArtistDetailViewController) {
        navigationController?.pushViewController(artistDetailView, animated: true)
    }
    func appDependenciesResolver() -> AppDependenciesResolver? {
        return appDependencies
    }
}
