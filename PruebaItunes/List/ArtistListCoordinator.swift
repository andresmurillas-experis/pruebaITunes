//
//  AlbumListCoordinator.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 19/5/23.
//

import Foundation
import UIKit
import Domain

class ArtistListCoordinator {
    private var appDependencies: AppDependencies
    private var nav: UINavigationController
    init(_ appDependencies : AppDependencies, navigationController: UINavigationController) {
        self.appDependencies = appDependencies
        nav = navigationController
    }
    func start() -> UINavigationController{
        let vm: ArtistListViewModel = appDependencies.resolve()
        let artistListViewController = ArtistListViewController(vm: vm)
        nav.pushViewController(artistListViewController, animated: true)
        nav.tabBarItem.image = UIImage(systemName: "magnifyingglass") ?? UIImage()
        return nav
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        let artistDetailCoordinator: ArtistDetailCoordinator = appDependencies.resolve()
        artistDetailCoordinator.start(with: artist)
    }
}
