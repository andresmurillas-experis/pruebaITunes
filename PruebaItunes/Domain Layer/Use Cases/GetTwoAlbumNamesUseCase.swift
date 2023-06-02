//
//  GetTwoAlbumNames.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/5/23.
//

import Foundation
import Combine

class GetTwoAlbumNamesUseCase {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    private var cancellables = [AnyCancellable]()
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        dataRepository = appDependencies.resolve()
    }
    func execute(albumId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        return dataRepository.getTwoAlbums(for: albumId)
    }
}
