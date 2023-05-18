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
    func resolve() -> WebAPIDataSource
    func resolve() -> ArtistListPresenterProtocol
    func resolve() -> ArtistListViewProtocol
}

extension AppDependenciesResolver {
    func resolve() -> WebAPIDataSource {
        WebAPIDataSource()
    }
    func resolve() -> ArtistListPresenterProtocol {
        ArtistListPresenter(appDependencies: self)
    }
    func resolve() -> ArtistDetailViewModel {
        ArtistDetailViewModel(appDependencies: self)
    }
    func resolve() -> ITunesDataRepository {
        ITunesDataRepository(appDependencies: self)
    }
    func resolve() -> ArtistListViewProtocol {
        ArtistListViewController(presenter: resolve())
    }
    func resolve() -> ArtistDataSource {
        ArtistDataSource(appDependencies: self)
    }
    func resolve() -> AlbumDataSource {
        AlbumDataSource(appDependencies: self)
    }
    func resolve(viewController: ArtistListViewController?) -> GetArtists {
        GetArtists(appDependencies: self, viewController: viewController)
    }
    func resolve() -> GetAlbums {
        GetAlbums(appDependencies: self)
    }
    func resolve() -> GetTwoAlbumNamesUseCase {
        GetTwoAlbumNamesUseCase(appDependencies: self)
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
        ArtistListViewController(presenter: appDependencies.resolve())
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        let vm: ArtistDetailViewModel = appDependencies.resolve()
        vm.setArtist(artist)
        let artistDetailView = ArtistDetailViewController(vm: vm)
        navigationController.pushViewController(artistDetailView, animated: true)
    }
}
