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

    func setContentsTo(artistName: String, disc1Name: String, discName2: String) {
        self.name.text = artistName
        self.disc1Name.text = disc1Name
        self.disc2Name.text = discName2
        moreContentExistsIndicator.isHidden = true
    }
    
    func setContentsTo(artist: ArtistViewModel) {
        self.name.text = artist.name
        self.disc1Name.text = artist.disc1Name
        self.disc2Name.text = artist.disc2Name
    }
    
}
