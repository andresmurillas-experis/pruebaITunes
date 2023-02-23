//
//  CellTableView.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit

class ArtistCell: UITableViewCell {
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var albumCover1: UIImageView!
    @IBOutlet private weak var albumCover2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        // Not sure if neaded
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContentsTo(label: String) {
        self.label.text = label
        // removed because couldn'y reference UIImage(named:String) when calling method
//        self.albumCover1.image = albumCover1
//        self.albumCover2.image = albumCover2
    }
    
}
