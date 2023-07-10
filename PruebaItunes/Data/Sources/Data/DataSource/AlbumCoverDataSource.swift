//
//  File.swift
//  
//
//  Created by Andrés Murillas on 27/6/23.
//

import Foundation
import Combine

    public class AlbumCoverDataSource {
    public static func downloadAlbumCover(from url: String) -> AnyPublisher<Data, WebAPIDataSource.NetworkError> {
        let downloadClient: WebAPIDataSource = WebAPIDataSource()
        return downloadClient.download(from: url)
    }
}
