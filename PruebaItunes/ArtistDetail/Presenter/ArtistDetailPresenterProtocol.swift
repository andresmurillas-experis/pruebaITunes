//
//  ArtistDetailProtocol.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation

protocol ArtistDetailPresenterProtocol {

    func download(url: String)

    func setviewdelegate(artistDetailViewDelegate: ArtistDetailViewProtocol?)

}
