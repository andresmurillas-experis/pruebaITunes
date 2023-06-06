//
//  DataRepository.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 9/5/23.
//

import Foundation
import Combine

protocol DataRepository {
    func getAllArtists(for artistName: String) -> AnyPublisher<[ArtistEntity], WebAPIDataSource.NetworkError>
    func getAllAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError>
    func getTwoAlbums(for artistId: Int) -> AnyPublisher<[String], WebAPIDataSource.NetworkError>
}

final class ITunesDataRepository: DataRepository {
    var appDependencies: AppDependenciesResolver
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
    func getAllArtists(for artistName: String) ->  AnyPublisher<[ArtistEntity], WebAPIDataSource.NetworkError> {
        let artistDataSource: ArtistDataSource = appDependencies.resolve()
        return artistDataSource.downloadAllArtists(for: artistName).map { artistDTO in
            artistDTO.results.map { artistResult in
                ArtistEntity(id: artistResult.artistId, name: artistResult.artistName)
            }
        }.eraseToAnyPublisher()
    }
    func getAllAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        let albumDataSource: AlbumDataSource = appDependencies.resolve()
        return albumDataSource.downloadAllAlbums(for: artistId)
    }
    func getTwoAlbums(for artistId: Int) -> AnyPublisher<[String], WebAPIDataSource.NetworkError> {
        let albumDataSource: AlbumDataSource = appDependencies.resolve()
        return albumDataSource.downloadTwoAlbums(for: artistId).map { albumDTO in
            var albums: [AlbumEntity] = albumDTO.results.map { albumResult in
                AlbumEntity(albumName: albumResult.collectionName, albumCover: albumResult.artworkUrl60, albumCoverLarge: albumResult.artworkUrl100)
            }
            for i in 0...2 {
                if albums.count <= i {
                    albums.append(AlbumEntity(albumName: nil, albumCover: nil, albumCoverLarge: nil))
                }
            }
            let albumNames: [String] = albums.map { album in
                album.albumName ?? ""
            }
            return albumNames
        }.eraseToAnyPublisher()
    }
}
