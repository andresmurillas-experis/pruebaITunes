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
    private var navigationController: UINavigationController
    private var appDependencies: AppDependencies
    init(_ appDependencies : AppDependencies, navigationController: UINavigationController) {
        self.appDependencies = appDependencies
        self.navigationController = navigationController
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        let artistDetailView: ArtistDetailCoordinator = appDependencies.resolve()
        artistDetailView.start(with: artist)
    }
}
