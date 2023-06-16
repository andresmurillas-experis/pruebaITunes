//
//  DataRepository.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 9/5/23.
//

import Foundation
import Combine

public protocol DataRepository {
    static func getAllArtists(for artistName: String) -> AnyPublisher<ArtistDTO, WebAPIDataSource.NetworkError>
    static func getAllAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError>
    static func getTwoAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError>
}

public final class ITunesDataRepository: DataRepository {
    public static func getAllArtists(for artistName: String) -> AnyPublisher<ArtistDTO, WebAPIDataSource.NetworkError> {
        ArtistDataSource.downloadAllArtists(for: artistName)
    }
    public static func getAllAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        AlbumDataSource.downloadAllAlbums(for: artistId)
    }
    public static func getTwoAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        AlbumDataSource.downloadTwoAlbums(for: artistId)
    }
}
