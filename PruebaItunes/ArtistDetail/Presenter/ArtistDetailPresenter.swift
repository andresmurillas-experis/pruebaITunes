//
//  ArtistDetailPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation
import UIKit

protocol ArtistDetailPresenterProtocol: UIViewController, AnyObject {
    var artistDetailView: ArtistDetailViewController? {get set}
    func setArtist(artist: ArtistViewModel)
}

class ArtistDetailPresenter: UIViewController {

    weak internal var artistDetailView: ArtistDetailViewController?

    var dataTask: URLSessionDataTask?

    private var artist: ArtistViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let artistId = self.artist?.id else {
            return
        }
        print(artistId)
        download(from: "https://itunes.apple.com/lookup?id=\(artistId)&entity=album") { [weak self] result in
            print(self, "download closure")
            switch result {
            case .success(let albumList):
                self?.artistDetailView?.setAlbumList(albumList)
            case .failure(let error):
                switch error {
                case .noData:
                    print("Network Service Error: ", error)
                case .serviceError:
                    print("No Data Eroor: ", error)
                case .parsing:
                    print("JSON Parsing Error: ", error)
                }
            }
        }
    }
}

extension ArtistDetailPresenter: ArtistDetailPresenterProtocol {

    func setArtist(artist: ArtistViewModel) {
        self.artist = artist
    }

}

private extension ArtistDetailPresenter {

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
            print(self, "datatask closure")
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
            albumList = iTunesAlbumModel.results.compactMap {
                if $0.collectionName == nil {
                    return nil
                }
                return AlbumViewModel(albumName: $0.collectionName, albumCover: $0.artworkUrl60, albumCoverLarge: $0.artworkUrl100)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return albumList
    }

}
