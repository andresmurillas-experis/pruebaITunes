//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit

class ArtistDetailViewController: UIViewController {

    @IBOutlet var artistNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        artistNameLabel.text = ""
    }

}
