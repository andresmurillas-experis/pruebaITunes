//
//  AlbumdataSource.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/5/23.
//

import Foundation

final class AlbumDataSource {
    var appDependencies: AppDependenciesResolver
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
    func getAllAlbums(for artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let dataRepository: DataRepository = appDependencies.resolve()
        dataRepository.downloadAllAlbums(for: artistId, completion: completion)
    }
    func getTwoFirstAlbums(for artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let dataRepository: DataRepository = appDependencies.resolve()
        dataRepository.downloadTwoAlbums(for: artistId, completion: completion)
    }
}
