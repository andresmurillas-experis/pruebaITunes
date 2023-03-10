//
//  AlbumViewCell.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 9/3/23.
//

import UIKit

final class AlbumViewCell: UITableViewCell {

    @IBOutlet private var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupViewModel (_ viewModel: AlbumViewModel) {
        self.name.text = viewModel.albumName
    }

    override func prepareForReuse() {
        name.text = ""
    }

}
