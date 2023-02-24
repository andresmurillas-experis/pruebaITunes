//
//  CellTableView.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit

final class ArtistCell: UITableViewCell {

    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var disc1Name: UILabel!
    @IBOutlet private weak var disc2Name: UILabel!
    @IBOutlet private weak var moreContentExistsIndicator: UILabel!

    override func prepareForReuse() {
        name.text = ""
        disc1Name.text = ""
        disc2Name.text = ""
    }

    func setupViewModel(_ viewModel: ArtistViewModel) {
        self.name.text = viewModel.name
        self.disc1Name.text = viewModel.disc1Name
        self.disc2Name.text = viewModel.disc2Name
        moreContentExistsIndicator.isHidden = true
    }

}
