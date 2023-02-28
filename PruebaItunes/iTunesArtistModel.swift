//
//  iTunesArtistModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/2/23.
//

import Foundation

    struct ArtistResult: Decodable {
         let wrapperType: String
         let artistType: String
         let artistName: String
         let artistLinkUrl: String
         let artistId: Int
         let amgArtistId: Int?
         let primaryGenreName: String?
         let primaryGenreId:Int?
    }

    struct ITunesArtistModel: Decodable {
        let resultCount: Int
        let results: [ArtistResult]
    }
