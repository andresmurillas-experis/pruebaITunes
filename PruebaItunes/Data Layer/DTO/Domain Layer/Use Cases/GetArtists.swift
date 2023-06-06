//
//  GetArtists.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 11/5/23.
//

import Foundation
import Combine

final class GetArtists {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
    }
    func execute(artistName: String) -> AnyPublisher<[ArtistEntity], WebAPIDataSource.NetworkError> {
        dataRepository.getAllArtists(for: artistName)
    }
}
