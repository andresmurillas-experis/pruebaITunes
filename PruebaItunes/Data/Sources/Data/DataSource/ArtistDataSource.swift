//
//  ArtistDataSrouce.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/5/23.
//

import Foundation
import Combine

public final class ArtistDataSource {
    public static func downloadAllArtists(for artistName: String) -> AnyPublisher<ArtistDTO, WebAPIDataSource.NetworkError> {
        let url = "https://itunes.apple.com/search?term=\(artistName)&entity=musicArtist&attribute=artistTerm"
        let downloadClient: WebAPIDataSource = WebAPIDataSource()
        return downloadClient.download(from: url)
    }
}
