//
//  DataRepository.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 9/5/23.
//

import Foundation

protocol DataRepository {
    func getAllArtists(for artistName: String, completion: @escaping (Result< ArtistDTO , WebAPIDataSource.NetworkError>) -> () )
    func getAllAlbums(for artistId: Int, completion: @escaping (Result< AlbumDTO , WebAPIDataSource.NetworkError>) -> () )
    func getTwoFirstAlbums(for artistId: Int, completion: @escaping  (Result< AlbumDTO , WebAPIDataSource.NetworkError>) -> ())
}

class ITunesDataRepository: DataRepository {
    var appDependencies: AppDependenciesResolver
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
    func getAllArtists(for artistName: String, completion: @escaping (Result<ArtistDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let downloadClient: ArtistDataSource = appDependencies.resolve()
        downloadClient.downloadArtistsFor(artistName: artistName, completion: completion)
    }
    func getAllAlbums(for artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let downloadClient: AlbumDataSource = appDependencies.resolve()
        downloadClient.downloadAllAlbumsFor(artistId: artistId, completion: completion)
    }
    func getTwoFirstAlbums(for artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let downloadClient: AlbumDataSource = appDependencies.resolve()
        downloadClient.downloadTwoAlbumsdFor(artistId: artistId, completion: completion)
    }
}
