//
//  iTunesArtistModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/2/23.
//

import Foundation

public struct ArtistResult: Decodable {
     public let wrapperType: String
     public let artistType: String
     public let artistName: String
     public let artistLinkUrl: String
     public let artistId: Int
     public let amgArtistId: Int?
     public let primaryGenreName: String?
     public let primaryGenreId:Int?
}

public struct ArtistDTO: Decodable {
    public let resultCount: Int
    public let results: [ArtistResult]
}
