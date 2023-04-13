//
//  AppDependencies.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/3/23.
//

import UIKit
import Foundation

protocol AppDependenciesResolver {
    func resolve() -> Coordinator
    func resolve() -> DownloadClient
    func resolve() -> ArtistListPresenterProtocol
    func resolve() -> ArtistListViewProtocol
}

extension AppDependenciesResolver {
    func resolve() -> DownloadClient {
        DownloadClient()
    }
    func resolve() -> ArtistListPresenterProtocol {
        ArtistListPresenter(appDependencies: self)
    }
    func resolve() -> ArtistDetailViewModel {
        ArtistDetailViewModel(appDependencies: self)
    }
    func resolve() -> ArtistListViewProtocol {
        ArtistListViewController(nibName: "ArtistListViewController", bundle: nil, presenter: resolve())
    }
}

final class AppDependencies {
    private let navigator: UINavigationController
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
}

extension AppDependencies: AppDependenciesResolver {
    func resolve() -> Coordinator {
        Coordinator(self, navigationController: navigator)
    }
}

struct Coordinator {
    private var navigationController: UINavigationController
    private var appDependencies: AppDependenciesResolver
    init(_ appDependencies : AppDependenciesResolver, navigationController: UINavigationController) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    func getInitialViewController() -> UIViewController {
        ArtistListViewController(nibName: "ArtistListViewController", bundle: nil, presenter: appDependencies.resolve())
    }
    func goToDetailViewForArtist(_ artist: ArtistModel) {
        let vm: ArtistDetailViewModel = appDependencies.resolve()
        vm.setArtist(artist)
        let artistDetailView = ArtistDetailViewController(nibName: "ArtistDetailViewController", bundle: nil, vm: vm)
        navigationController.pushViewController(artistDetailView, animated: true)
    }
}
