//
//  CollectionViewCell.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/3/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumCover: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupViewModel(_ viewModel: AlbumViewModel) {
        albumName.text = viewModel.albumName
    }
    
}
