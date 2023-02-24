//
//  ArtistListViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit

final class ArtistListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let artistList = [
        ArtistViewModel(name: "aaa", disc1Name: "bbb", disc2Name: "ccc"),
        ArtistViewModel(name: "ccc", disc1Name: "ddd", disc2Name: "eee"),
        ArtistViewModel(name: "fff", disc1Name: "ggg", disc2Name: "hhh")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
}

    

extension ArtistListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCellReuseIdentifier", for: indexPath) as? ArtistCell else {
            return UITableViewCell()
        }
        let artist = artistList[indexPath.item]
        cell.setContentsTo(artist: artist)
        return cell
    }

}

private extension ArtistListViewController {
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ArtistCellView", bundle: nil), forCellReuseIdentifier: "ArtistCellReuseIdentifier")
    }
    
}
