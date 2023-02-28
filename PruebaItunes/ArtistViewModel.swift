//
//  ArtistViewModel.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 24/2/23.
//

import Foundation

struct ArtistViewModel {
    let name: String
    let discOneName: String?
    let discTwoName: String?

    init(name: String, discOneName: String? = nil, discTwoName: String? = nil) {
        self.name = name
        self.discOneName = discOneName
        self.discTwoName = discTwoName
    }
}
