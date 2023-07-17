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
//    func resolve() -> UITabBarController
}

final class AppDependencies {
    private let nav: UINavigationController
    init(navigator: UINavigationController) {
        self.nav = navigator
    }
}

extension AppDependencies: AppDependenciesResolver {
    func resolve() -> ArtistListCoordinator {
        ArtistListCoordinator(self)
    }
    func resolve() -> ArtistDetailCoordinator {
        ArtistDetailCoordinator(self, navigationController: nav)
    }
    func resolve() -> ArtistDetailViewModel {
        ArtistDetailViewModel()
    }
    func resolve() -> ArtistListViewModel {
        ArtistListViewModel(self)
    }
//    func resolve() -> UITabBarController {
//        TabBar()
//    }
}
