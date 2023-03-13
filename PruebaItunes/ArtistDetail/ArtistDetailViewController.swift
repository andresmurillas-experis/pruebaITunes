//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit

final class ArtistDetailViewController: UIViewController {

    @IBOutlet private var artistNameLabel: UILabel!

    @IBOutlet private weak var tableView: UICollectionView!

    private var artist: ArtistViewModel?

    private var albumList: [AlbumViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var dataTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        artistNameLabel.text = ""

        guard let artistId = artist?.id else {
            return
        }

        download(from: "https://itunes.apple.com/lookup?id=\(artistId)&entity=album") { [weak self] result in
            switch result {
            case .success(let albumList):
                self?.albumList = albumList
            case .failure(let error):
                switch error {
                case .noData:
                    print("Error: Network Service Error: ", error)
                case .serviceError:
                    print("Error: No Data Eroor: ", error)
                case .parsing:
                    print("Error: JSON Parsong Error: ", error)
                }
            }
        }
        setTableView()
    }

    func setArtist(_ artist: ArtistViewModel) {
        self.artist = artist
    }

}

extension ArtistDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tableView.dequeueReusableCell(withReuseIdentifier: "AlbumCellReuseIdentifier", for: indexPath) as? AlbumViewCell else {
            return UICollectionViewCell()
        }
        cell.setupViewModel(albumList[indexPath.item])
        return cell
    }

}

private extension ArtistDetailViewController {

    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AlbumView", bundle: nil), forCellWithReuseIdentifier: "AlbumCellReuseIdentifier")
    }

}

extension ArtistDetailViewController {

    enum NetworkError: Error {
        case serviceError, noData, parsing
    }

    func download(from url: String, completionHandler: @escaping (Result<[AlbumViewModel], NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        dataTask?.cancel()
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in
            if error != nil {
                completionHandler(.failure(NetworkError.serviceError))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            guard let albumList = self?.decodeJSONFromData(data) else {
                completionHandler(.failure(NetworkError.parsing))
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success(albumList))
            }
        }.resume()
    }

    func decodeJSONFromData(_ data: Data) -> [AlbumViewModel]? {
        let stringData = String(data: data, encoding: .utf8)!
        let json = stringData.data(using: .utf8)!
        var albumList: [AlbumViewModel] = []
        do {
            let decoder = JSONDecoder()
            let iTunesAlbumModel: ITunesAlbumModel = try decoder.decode(ITunesAlbumModel.self, from: json)
            albumList = iTunesAlbumModel.results.map {
                return AlbumViewModel(albumName: $0.collectionName, albumCover: $0.artworkUrl60, albumCoverLarge: $0.artworkUrl100)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return albumList
    }

}
