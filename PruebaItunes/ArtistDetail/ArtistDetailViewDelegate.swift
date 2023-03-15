//
//  ArtistDetailViewDelegate.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation

protocol ArtistDetailViewDelegate: AnyObject {
    
    func setAlbumList(_ albumList: [AlbumViewModel])
    
}
