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
    private var cancellables = [AnyCancellable]()
    private var subject: CurrentValueSubject<[AlbumEntity?], WebAPIDataSource.NetworkError>
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
        self.dataRepository = appDependencies.resolve()
        self.subject = CurrentValueSubject([])
    }
    func execute(albumId: (Int)) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        return dataRepository.getAllAlbums(for: albumId)
    }
}
