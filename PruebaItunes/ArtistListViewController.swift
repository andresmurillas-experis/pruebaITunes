//
//  ArtistListViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit

final class ArtistListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    var dataTask: URLSessionDataTask?
    
    private let artistList = [
        ArtistViewModel(name: "aaa", discOneName: "bbb", discTwoName: "ccc"),
        ArtistViewModel(name: "ccc", discOneName: "ddd", discTwoName: "eee"),
        ArtistViewModel(name: "fff", discOneName: "ggg", discTwoName: "hhh")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        
        download()
    }
    
}

extension ArtistListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCellReuseIdentifier", for: indexPath) as? ArtistCell else {
            return UITableViewCell()
        }
        let artist = artistList[indexPath.item]
        cell.setupViewModel(artist)
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

private extension ArtistListViewController {

    func download() {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=909253") else {
            print("Invalid URL")
            return
        }
        dataTask?.cancel()
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("error")
                return
            }
            if let dataString = String(data: data, encoding: .utf8) {
                print("Downloaded data: \(dataString)")
            }
        }
        dataTask.resume()
    }

}
