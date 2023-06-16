//
//  AlbumViewModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 8/3/23.
//

import Foundation

public struct AlbumEntity: Codable{
    public let albumName: String?
    public let albumCover: String?
    public let albumCoverLarge: String?
    public init () {
        albumName = nil
        albumCover = nil
        albumCoverLarge = nil
    }
    public init(albumName: String?, albumCover: String?, albumCoverLarge: String?) {
        self.albumName = albumName
        self.albumCover = albumCover
        self.albumCoverLarge = albumCoverLarge
    }
}
