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
    func resolve() -> ArtistDetailViewModel {
        ArtistDetailViewModel()
    }
    func resolve() -> ArtistListViewModel {
        ArtistListViewModel(appDependencies: self )
    }
}
