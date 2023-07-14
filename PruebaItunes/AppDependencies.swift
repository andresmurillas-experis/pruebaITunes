//
//  AppDependencies.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/3/23.
//

import UIKit
import Foundation

protocol AppDependenciesResolver {
    var nav: UINavigationController? { get }
    func resolve() -> ArtistListViewModel
    func resolve() -> ArtistDetailViewModel
    func resolve() -> ArtistListCoordinator
    func resolve() -> ArtistDetailCoordinator
}

final class AppDependencies {
    let nav: UINavigationController?
    init(navigator: UINavigationController?) {
        self.nav = navigator
    }
}

extension AppDependencies: AppDependenciesResolver {
    func resolve() -> ArtistListCoordinator {
        ArtistListCoordinator(self)
    }
    func resolve() -> ArtistListViewModel {
        ArtistListViewModel(self)
    }
    func resolve() -> ArtistDetailCoordinator {
        ArtistDetailCoordinator(self, navigationController: nav)
    }
    func resolve() -> ArtistDetailViewModel {
        ArtistDetailViewModel()
    }
}
