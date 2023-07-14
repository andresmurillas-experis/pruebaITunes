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
    init(_ appDependencies : AppDependencies) {
        self.appDependencies = appDependencies
    }
    func goToDetailViewForArtist(_ artist: ArtistEntity) {
        let artistDetailCoordinator: ArtistDetailCoordinator = appDependencies.resolve()
        artistDetailCoordinator.startView(for: artist)
    }
}
