//
//  AlbumdataSource.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/5/23.
//

import Foundation

class AlbumDataSource {
    var appDependencies: AppDependenciesResolver
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
    func downloadAllAlbumsFor(artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let url = "https://itunes.apple.com/lookup?id=\(artistId)&entity=album"
        let downloadClient: WebAPIDataSource = appDependencies.resolve()
        downloadClient.download(from: url, completionHandler: completion)
    }
    func downloadTwoAlbumsdFor(artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let url = "https://itunes.apple.com/lookup?id=\(artistId)&entity=album&limit=2"
        let downloadClient: WebAPIDataSource = appDependencies.resolve()
        downloadClient.download(from: url, completionHandler: completion)
    }
}
