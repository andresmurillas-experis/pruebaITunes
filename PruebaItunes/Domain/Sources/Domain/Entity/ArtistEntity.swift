//
//  ArtistViewModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/2/23.
//

import Foundation

public struct ArtistEntity: Codable {
    public let id: Int
    public let name: String
    public var discOneName: String?
    public var discTwoName: String?
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    public init(id: Int, name: String, discOneName: String?, discTwoName: String?) {
        self.id = id
        self.name = name
        self.discOneName = discOneName
        self.discTwoName = discTwoName
    }
}
