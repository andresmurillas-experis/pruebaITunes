//
//  DataRepository.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 9/5/23.
//

import Foundation

protocol DataRepository {
    func downloadAllArtists(for artistName: String, completion: @escaping (Result< ArtistDTO , WebAPIDataSource.NetworkError>) -> () )
    func downloadAllAlbums(for artistId: Int, completion: @escaping (Result< AlbumDTO , WebAPIDataSource.NetworkError>) -> () )
    func downloadTwoAlbums(for artistId: Int, completion: @escaping  (Result< AlbumDTO , WebAPIDataSource.NetworkError>) -> ())
}

class ITunesDataRepository: DataRepository {
    var appDependencies: AppDependenciesResolver
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
    func downloadAllArtists(for artistName: String, completion: @escaping (Result<ArtistDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let url = "https://itunes.apple.com/search?term=\(artistName)&entity=musicArtist&attribute=artistTerm"
        let downloadClient: WebAPIDataSource = appDependencies.resolve()
        downloadClient.download(from: url, completionHandler: completion)
    }
    func downloadAllAlbums(for artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let url = "https://itunes.apple.com/lookup?id=\(artistId)&entity=album"
        let downloadClient: WebAPIDataSource = appDependencies.resolve()
        downloadClient.download(from: url, completionHandler: completion)
    }
    func downloadTwoAlbums(for artistId: Int, completion: @escaping (Result<AlbumDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let url = "https://itunes.apple.com/lookup?id=\(artistId)&entity=album&limit=2"
        let downloadClient: WebAPIDataSource = appDependencies.resolve()
        downloadClient.download(from: url, completionHandler: completion)
    }
}
