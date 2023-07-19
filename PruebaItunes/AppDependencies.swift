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
    func resolve() -> ArtistListCoordinator
    func resolve() -> ArtistDetailViewModel
    func resolve() -> ArtistDetailCoordinator
    func resolve() -> SettingsViewModel
    func resolve() -> SettingsCoordinator
}

final class AppDependencies {
    private let nav: UINavigationController
    init(navigationController nav: UINavigationController) {
        self.nav = nav
    }
}

extension AppDependencies: AppDependenciesResolver {
    func resolve() -> ArtistListViewModel {
        ArtistListViewModel(self)
    }
    func resolve() -> ArtistListCoordinator {
        ArtistListCoordinator(self, navigationController: nav)
    }
    func resolve() -> ArtistDetailViewModel {
        ArtistDetailViewModel()
    }
    func resolve() -> ArtistDetailCoordinator {
        ArtistDetailCoordinator(self, navigationController: nav)
    }
    func resolve() -> SettingsViewModel {
        SettingsViewModel(self)
    }
    func resolve() -> SettingsCoordinator {
        SettingsCoordinator(self, navigationController: UINavigationController())
    }
}
