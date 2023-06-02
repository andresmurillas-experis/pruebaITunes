//
//  GetArtists.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 11/5/23.
//

import UIKit
import Foundation
import Combine

final class GetArtists {
    private var appDependencies: AppDependenciesResolver
    private var dataRepository: DataRepository
    private var subject: CurrentValueSubject<[ArtistEntity?], WebAPIDataSource.NetworkError>
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
        self.subject = CurrentValueSubject([])
    }
    func execute(artistName: String) -> AnyPublisher<ArtistDTO, WebAPIDataSource.NetworkError> {
        return dataRepository.getAllArtists(for: artistName)
    }
}
