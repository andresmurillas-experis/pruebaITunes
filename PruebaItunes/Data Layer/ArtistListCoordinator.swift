//
//  ArtistListCoordinator.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 19/5/23.
//

import Foundation
import UIKit

struct ArtistListCoordinator {
    private var navigationController: UINavigationController
    private var appDependencies: AppDependenciesResolver
    init(_ appDependencies : AppDependenciesResolver, navigationController: UINavigationController) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    func getArtistListViewController() -> UIViewController {
        ArtistListViewController(presenter: appDependencies.resolve())
    }
}
