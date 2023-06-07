//
//  GetTwoAlbumNames.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/5/23.
//

import Foundation
import Combine

final class GetTwoAlbumNamesUseCase {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        dataRepository = appDependencies.resolve()
    }
    func execute(albumId: Int) -> AnyPublisher<[String], WebAPIDataSource.NetworkError> {
        dataRepository.getTwoAlbums(for: albumId)
    }
}
