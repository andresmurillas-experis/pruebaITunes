//
//  ArtistDetailCoordinator.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 19/5/23.
//

import Foundation
import UIKit
import Domain

class ArtistDetailCoordinator {
    private var navigationController: UINavigationController
    private var appDependencies: AppDependenciesResolver
    public init(_ appDependencies: AppDependenciesResolver, navigationController: UINavigationController) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    func start(with artist: ArtistEntity) {
        let vm: ArtistDetailViewModel = appDependencies.resolve()
        vm.setArtist(artist)
        let artistDetailViewController = ArtistDetailViewController(vm: vm)
        artistDetailViewController.hidesBottomBarWhenPushed = true
        print(navigationController, "two")
        navigationController.pushViewController(artistDetailViewController, animated: true)
    }
}
