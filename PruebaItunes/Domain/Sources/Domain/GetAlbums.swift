//
//  GetTwoAlbumNames.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/5/23.
//

import Foundation
import Combine
import Data

@available(iOS 13.0, *)
public final class GetAlbums {
    public static func execute(albumId: (Int)) -> AnyPublisher<[AlbumEntity], WebAPIDataSource.NetworkError> {
        return ITunesDataRepository.getAllAlbums(for: albumId).map { albumDTO in
            return albumDTO.results.map { result in
                return AlbumEntity(albumName: result.collectionName, albumCover: result.artworkUrl60, albumCoverLarge: result.artworkUrl100)
            }
        }.eraseToAnyPublisher()
    }
}
