//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit

final class ArtistDetailViewController: UIViewController {

    @IBOutlet private var artistNameLabel: UILabel!
    
    private var artist: ArtistViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        artistNameLabel.text = ""
    }
    
    func setArtist(artist: ArtistViewModel) {
        self.artist = artist
    }

}
