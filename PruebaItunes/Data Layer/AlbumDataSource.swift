//
//  AlbumdataSource.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/5/23.
//

import Foundation
import Combine

final class AlbumDataSource {
    var appDependencies: AppDependenciesResolver
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
    func downloadAllAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        let url = "https://itunes.apple.com/lookup?id=\(artistId)&entity=album"
        let downloadClient: WebAPIDataSource = appDependencies.resolve()
        return downloadClient.download(from: url)
    }
    func downloadTwoAlbums(for artistId: Int) -> AnyPublisher<AlbumDTO, WebAPIDataSource.NetworkError> {
        let url = "https://itunes.apple.com/lookup?id=\(artistId)&entity=album&limit=2"
        let downloadClient: WebAPIDataSource = appDependencies.resolve()
        return downloadClient.download(from: url)

    }
}
