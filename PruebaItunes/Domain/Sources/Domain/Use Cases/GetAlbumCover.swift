//
//  File.swift
//  
//
//  Created by Andrés Murillas on 27/6/23.
//

import Foundation
import Combine
import Data

public final class GetAlbumCover {
    public static func execute(albumCover: String) -> AnyPublisher<Data, WebAPIDataSource.NetworkError> {
        return ITunesDataRepository.getAlbumCover(from: albumCover).eraseToAnyPublisher()
    }
}
