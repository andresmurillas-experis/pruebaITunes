//
//  ArtistViewModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/2/23.
//

import Foundation

struct ArtistEntity: Codable {
    let id: Int
    let name: String
    var discOneName: String?
    var discTwoName: String?
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    mutating func setDiscNames (discOneName: String?, discTwoName: String?) {
        self.discOneName = discOneName
        self.discTwoName = discTwoName
    }
}
