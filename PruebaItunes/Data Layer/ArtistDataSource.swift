//
//  ArtistDataSrouce.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/5/23.
//

import Foundation
import Combine

final class ArtistDataSource {
    var appDependencies: AppDependenciesResolver
    init(appDependencies: AppDependenciesResolver) {
        self.appDependencies = appDependencies
    }
    func downloadAllArtists(for artistName: String) -> AnyPublisher<ArtistDTO, WebAPIDataSource.NetworkError> {
        let url = "https://itunes.apple.com/search?term=\(artistName)&entity=musicArtist&attribute=artistTerm"
        let downloadClient: WebAPIDataSource = appDependencies.resolve()
        return downloadClient.download(from: url)
    }
}
