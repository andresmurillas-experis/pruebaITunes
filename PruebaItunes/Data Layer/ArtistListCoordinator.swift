//
//  AlbumListCoordinator.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 19/5/23.
//

import Foundation
import UIKit

class ArtistListCoordinator {
    private var navigationController: UINavigationController
    private var appDependencies: AppDependenciesResolver
    init(_ appDependencies : AppDependenciesResolver, navigationController: UINavigationController) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        let vm: ArtistDetailViewModel = appDependencies.resolve()
        vm.setArtist(artist)
        let artistDetailView = ArtistDetailViewController(vm: vm)
        navigationController.pushViewController(artistDetailView, animated: true)
    }
}
