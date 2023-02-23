//
//  ViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/2/23.
//

import UIKit

class ViewController: UIViewController {

    let artistListViewController = ArtistListViewController(nibName: "ArtistListViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func showArtistListView(_ sender: Any) {
        
        navigationController?.pushViewController(artistListViewController, animated: true)
    }
    

}

