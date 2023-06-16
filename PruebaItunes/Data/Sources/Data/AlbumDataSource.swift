//
//  AlbumdataSource.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/5/23.
//

import Foundation
import Combine

public class AlbumDataSource {
    public static func downloadAllAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        let url = "https://itunes.apple.com/lookup?id=\(artistId)&entity=album"
        let downloadClient: WebAPIDataSource = WebAPIDataSource()
        return downloadClient.download(from: url)
    }
    public static func downloadTwoAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        let url = "https://itunes.apple.com/lookup?id=\(artistId)&entity=album&limit=2"
        let downloadClient: WebAPIDataSource = WebAPIDataSource()
        return downloadClient.download(from: url)
    }
}
