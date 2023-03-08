//
//  AlbumViewModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 8/3/23.
//

import Foundation

struct AlbumResult: Decodable {
    let collectionName: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
}

struct ITunesAlbumModel: Decodable {
    let resultCount: Int
    let results: [AlbumResult]
}
