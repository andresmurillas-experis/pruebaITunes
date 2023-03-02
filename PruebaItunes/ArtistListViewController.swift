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

    var artistList: [ArtistViewModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        download(from: "https://itunes.apple.com/search?term=metallica&entity=musicArtist&attribute=artistTerm") { [weak self] result in
            switch result {
            case . success(let artistList):
                self?.artistList = artistList
            case .failure(let error):
                print("Error: ", error)
            }
        }
        setTableView()
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

    func download(from url: String, handler: @escaping (Result<[ArtistViewModel], Error>) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        dataTask?.cancel()
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            guard let data = data else {
                return
            }
            guard let artistList = self?.decodeJSONFromData(data) else {
                return
            }
            DispatchQueue.main.async {
                handler(.success(artistList))
            }
        }.resume()
        

    }

    func decodeJSONFromData(_ data: Data) -> [ArtistViewModel]{
        let stringData = String(data: data, encoding: .utf8)!
        let json = stringData.data(using: .utf8)!
        var artistList: [ArtistViewModel] = []
        do {
            let decoder = JSONDecoder()
            let iTunesArtistModel: ITunesArtistModel = try decoder.decode(ITunesArtistModel.self, from: json)
            artistList = iTunesArtistModel.results.map { ArtistViewModel(name: $0.artistName) }
        } catch {
            print("Error: \(error.localizedDescription)")
            
        }
        return artistList
    }

}
