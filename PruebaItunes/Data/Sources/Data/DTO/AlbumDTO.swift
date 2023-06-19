//
//  AlbumViewModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 8/3/23.
//

import Foundation

public struct AlbumResult: Decodable {
    public let collectionName: String?
    public let artworkUrl60: String?
    public let artworkUrl100: String?
}

public struct AlbumDTO: Decodable {
    public let resultCount: Int
    public let results: [AlbumResult]
}
