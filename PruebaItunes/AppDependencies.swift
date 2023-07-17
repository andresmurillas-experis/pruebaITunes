//
//  AppDependencies.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/3/23.
//

import UIKit
import Foundation

protocol AppDependenciesResolver {
    func resolve() -> ArtistListViewModel
    func resolve() -> ArtistDetailViewModel
    func resolve() -> ArtistListCoordinator
    func resolve() -> ArtistDetailCoordinator
}

final class AppDependencies {
    private let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension AppDependencies: AppDependenciesResolver {
    func resolve() -> ArtistListCoordinator {
        ArtistListCoordinator(self, navigationController: navigationController)
    }
    func resolve() -> ArtistDetailCoordinator {
        ArtistDetailCoordinator(self, navigationController: navigationController)
    }
    func resolve() -> ArtistDetailViewModel {
        ArtistDetailViewModel()
    }
    func resolve() -> ArtistListViewModel {
        ArtistListViewModel(self)
    }
}
