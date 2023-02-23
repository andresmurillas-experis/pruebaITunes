//
//  CellTableView.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit

final class ArtistCell: UITableViewCell {
    
    @IBOutlet private weak var artistName: UILabel!
    @IBOutlet private weak var discName1: UILabel!
    @IBOutlet private weak var discName2: UILabel!
    @IBOutlet private weak var moreContentExistsIndicator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        discName1.text = ""
        discName2.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContentsTo(artistName: String, discName1: String, discName2: String) {
        self.artistName.text = artistName
        self.discName1.text = discName1
        self.discName2.text = discName2
        moreContentExistsIndicator.isHidden = true
    }
    
}
