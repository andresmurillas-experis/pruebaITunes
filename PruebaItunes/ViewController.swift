//
//  ViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/2/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showArtistListView(_ sender: Any) {
        let artistListViewController = ArtistListViewController(nibName: "ArtistListViewController", bundle: nil)
        navigationController?.pushViewController(artistListViewController, animated: true)
    }

}
