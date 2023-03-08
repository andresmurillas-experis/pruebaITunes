//
//  ArtistViewModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/2/23.
//

import Foundation

struct ArtistViewModel {
    let id: Int
    let name: String
    let discOneName: String?
    let discTwoName: String?

    init(id: Int, name: String, discOneName: String? = nil, discTwoName: String? = nil) {
        self.id = id
        self.name = name
        self.discOneName = discOneName
        self.discTwoName = discTwoName
    }
}
