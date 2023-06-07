//
//  GetTwoAlbumNames.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/5/23.
//

import Foundation
import Combine

final class GetAlbums {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    private var viewController: ArtistDetailViewController?
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
    }
    func execute(albumId: (Int)) -> AnyPublisher<[AlbumEntity], WebAPIDataSource.NetworkError> {
        return dataRepository.getAllAlbums(for: albumId)
    }
}
