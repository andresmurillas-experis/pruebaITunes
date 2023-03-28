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
}

class AppDependencies: AppDependenciesResolver {
    private var navigator: UINavigationController
    init(navigationController navigator: UINavigationController) {
        self.navigator = navigator
    }
    func resolve() -> DownloadClient {
        return DownloadClient()
    }
    func resolve() -> Coordinator {
        return Coordinator(navigationController: navigator)
    }
}

struct Coordinator {
    private var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func goTo(_ artistDetailView: ArtistDetailViewController) {
        navigationController.pushViewController(artistDetailView, animated: true)
    }
}
