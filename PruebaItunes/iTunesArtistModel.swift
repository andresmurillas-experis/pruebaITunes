//
//  iTunesArtistModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/2/23.
//

import Foundation

struct Result: Codable {
     let wrapperType: String
     let artistType: String
     let artistName: String
     let artistLinkUrl: String
     let artistId: Int
     let amgArtistId: Int
     let primaryGenreName: String
     let primaryGenreId:Int
}

struct iTunesArtistModel: Codable {
    let resultCount: Int
    let results: [Result]
}

