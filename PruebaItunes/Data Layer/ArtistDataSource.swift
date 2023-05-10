//
//  ArtistDataSrouce.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/5/23.
//

import Foundation

class ArtistDataSource {
    var appDependencies: AppDependenciesResolver
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
    func downloadArtistsFor(artistName: String, completion: @escaping (Result<ArtistDTO, WebAPIDataSource.NetworkError>) -> ()) {
        let url = "https://itunes.apple.com/search?term=\(artistName)&entity=musicArtist&attribute=artistTerm"
        let downloadClient: WebAPIDataSource = appDependencies.resolve()
        downloadClient.download(from: url, completionHandler: completion)
    }
}
