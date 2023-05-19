//
//  DataRepository.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 9/5/23.
//

import Foundation

protocol DataRepository {
    func getAllArtists(for artistName: String, completion: @escaping (Result<ArtistDTO , WebAPIDataSource.NetworkError>) -> ())
    func getAllAlbums(for artistId: Int, completion: @escaping (Result<AlbumDTO , WebAPIDataSource.NetworkError>) -> ())
    func getTwoAlbums(for artistId: Int, completion: @escaping  (Result<AlbumDTO , WebAPIDataSource.NetworkError>) -> ())
}

final class ITunesDataRepository: DataRepository {
    var appDependencies: AppDependencies
    init(appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
    }
    func getAllArtists(for artistName: String, completion: @escaping (Result<ArtistDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let artistDataSource: ArtistDataSource = appDependencies.resolve()
        artistDataSource.downloadAllArtists(for: artistName, completion:  completion)
    }
    func getAllAlbums(for artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let albumDataSource: AlbumDataSource = appDependencies.resolve()
        albumDataSource.downloadAllAlbums(for: artistId, completion: completion)
    }
    func getTwoAlbums(for artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let albumDataSource: AlbumDataSource = appDependencies.resolve()
        albumDataSource.downloadTwoAlbums(for: artistId, completion: completion)
    }
}
