//
//  DataRepository.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 9/5/23.
//

import Foundation
import Combine

protocol DataRepository {
    func getAllArtists(for artistName: String) -> AnyPublisher<ArtistDTO, WebAPIDataSource.NetworkError>
    func getAllAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError>
    func getTwoAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError>
}

final class ITunesDataRepository: DataRepository {
    var appDependencies: AppDependenciesResolver
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
    func getAllArtists(for artistName: String) ->  AnyPublisher<ArtistDTO, WebAPIDataSource.NetworkError> {
        let artistDataSource: ArtistDataSource = appDependencies.resolve()
        return artistDataSource.downloadAllArtists(for: artistName)
    }
    func getAllAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        let albumDataSource: AlbumDataSource = appDependencies.resolve()
        return albumDataSource.downloadAllAlbums(for: artistId)
    }
    func getTwoAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        let albumDataSource: AlbumDataSource = appDependencies.resolve()
        return albumDataSource.downloadTwoAlbums(for: artistId)
    }
}
