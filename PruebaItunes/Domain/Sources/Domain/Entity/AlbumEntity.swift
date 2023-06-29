//
//  AlbumViewModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 8/3/23.
//

import Foundation

public struct AlbumEntity: Codable{
    public let name: String?
    public let cover: String?
    public let coverLarge: String?
    public init () {
        name = nil
        cover = nil
        coverLarge = nil
    }
    public init(albumName: String?, albumCover: String?, albumCoverLarge: String?) {
        self.name = albumName
        self.cover = albumCover
        self.coverLarge = albumCoverLarge
    }
}
