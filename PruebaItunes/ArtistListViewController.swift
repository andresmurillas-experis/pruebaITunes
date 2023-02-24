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
        ArtistViewModel(name: "aaa", discOneName: "bbb", discTwoName: "ccc"),
        ArtistViewModel(name: "ccc", discOneName: "ddd", discTwoName: "eee"),
        ArtistViewModel(name: "fff", discOneName: "ggg", discTwoName: "hhh")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        guard let destination = URL(string: "https://itunes.apple.com/lookup?id=909253") else {
            print("e3213fe1321d13")
            return
        }
        Task {
            do {
                try await download(from: destination)
            } catch {
                
            }
            

        }

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
    
    func download(from downloadURL: URL) async throws {
        var sessionConfiguration = URLSessionConfiguration.default
        print(downloadURL)
        print("pirates")
        var session = URLSession(configuration: sessionConfiguration)

        var (downloaded, _) = try await session.download(from: downloadURL)
                
        print(downloaded)
        
        var data: Data = try Data(contentsOf: downloaded)
                    
        print(data)
        
        let decoder = JSONDecoder()
//        var decoded: iTunesArtistModel
        do {
            print(data.isEmpty)
            let decoded = try decoder.decode(iTunesArtistModel.self, from: data)
            print("dwqfewqfewfewq\(decoded)")
        } catch {
            print("nope")
        }
    }
}
