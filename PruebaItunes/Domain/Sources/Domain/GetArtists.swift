//
//  GetArtists.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 11/5/23.
//

import Foundation
import Combine
import Data

public final class GetArtists {
    public static func execute(artistName: String) -> AnyPublisher<[ArtistEntity], WebAPIDataSource.NetworkError> {
        return ITunesDataRepository.getAllArtists(for: artistName).map { artistDTO in
            artistDTO.results.map { result in
                ArtistEntity(id: result.artistId, name: result.artistName, discOneName: nil, discTwoName: nil)
            }
        }.eraseToAnyPublisher()
    }
}
