//
//  GetTwoAlbumNames.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 12/5/23.
//

import Foundation
import Combine
import Data

public final class GetTwoAlbumNames {
    public static func execute(albumId: Int) -> AnyPublisher<[String], WebAPIDataSource.NetworkError> {
        ITunesDataRepository.getTwoAlbums(for: albumId).map { albumDTO in
            let names: [String] = albumDTO.results.map { result in
                return result.collectionName ?? ""
            }
            return names
        }.eraseToAnyPublisher()
    }
}
