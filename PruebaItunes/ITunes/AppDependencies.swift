//
//  AppDependencies.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/3/23.
//

import UIKit
import Foundation

protocol AppDependenciesResolver {
    var coordinator: Coordinator { get set }
    func resolve() -> DownloadClient
}

class AppDependencies: AppDependenciesResolver {
    var coordinator: Coordinator
    var appDependencies: AppDependenciesResolver?
    func resolve() -> DownloadClient {
        return DownloadClient()
    }
 
    init(navigatorContorller navigator: UINavigationController) {
        print("Hurra")
        coordinator = Coordinator(navigatorContorller: navigator)
    }

}

struct Coordinator {
    private var navigatorController: UINavigationController
    init(navigatorContorller: UINavigationController) {
        self.navigatorController = navigatorContorller
    }
    func goTo(_ artistDetailView: ArtistDetailViewController) {
        navigatorController.pushViewController(artistDetailView, animated: true)
        artistDetailView.appDependencies = AppDependencies(navigatorContorller: navigatorController)
    }
}
