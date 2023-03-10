//
//  CollectionViewCell.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/3/23.
//

import UIKit

final class AlbumViewCell: UICollectionViewCell {

    @IBOutlet private weak var albumName: UILabel!
    @IBOutlet private weak var albumCover: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupViewModel(_ viewModel: AlbumViewModel) {
        albumName.text = viewModel.albumName
    }
    
    func downloadAlbumCover(from url: URL) {
        
    }
    
}
