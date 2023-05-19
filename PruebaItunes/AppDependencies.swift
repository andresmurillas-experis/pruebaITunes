//
//  AppDependencies.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/3/23.
//

import UIKit
import Foundation

protocol AppDependenciesResolver {
    func resolve() -> ArtistDetailCoordinator
    func resolve() -> WebAPIDataSource
    func resolve() -> ArtistListPresenterProtocol
    func resolve() -> ArtistListViewProtocol
    func resolve() -> ArtistDetailViewModel
    func resolve() -> ArtistListCoordinator
}

extension AppDependenciesResolver {
    func resolve() -> ArtistDetailViewModel {
        ArtistDetailViewModel(appDependencies: self)
    }
    func resolve() -> WebAPIDataSource {
        WebAPIDataSource()
    }
    func resolve() -> ArtistListPresenterProtocol {
        ArtistListPresenter(appDependencies: self)
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
        GetArtists(appDependencies: self)
    }
    func resolve() -> GetAlbums {
        GetAlbums(appDependencies: self as! AppDependencies)
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
    func resolve() -> ArtistListCoordinator {
        ArtistListCoordinator(self, navigationController: navigator)
    }
    func resolve() -> ArtistDetailCoordinator {
        ArtistDetailCoordinator(self, navigationController: navigator)
    }
}

