//
//  ArtistListPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 22/3/23.
//

import Foundation

protocol ArtistListPresenterProtocol: AnyObject {
    var artistListView: ArtistListViewController? { get set }
    func viewDidLoad()
}

final class ArtistListPresenter  {

    private var dataTask: URLSessionDataTask?
    weak var artistListView: ArtistListViewController?

}

extension ArtistListPresenter: ArtistListPresenterProtocol {
    
    func viewDidLoad() {
        download(from: "https://itunes.apple.com/search?term=metallica&entity=musicArtist&attribute=artistTerm") { [weak self] result in
            switch result {
            case .success(let artistList):
                self?.artistListView?.setArtistList(artistList)
                print(artistList)
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
    }
    
}

private extension ArtistListPresenter {

    enum NetworkError: Error {
        case serviceError, noData, parsing
    }

    func download(from url: String, completionHandler: @escaping (Result<[ArtistViewModel], NetworkError>) -> Void) {
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
            guard let artistList = self?.decodeArtistsFromJSON(data) else {
                completionHandler(.failure(NetworkError.parsing))
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success(artistList))
            }
        }.resume()
    }

    func decodeArtistsFromJSON(_ data: Data) -> [ArtistViewModel] {
        let stringData = String(data: data, encoding: .utf8)!
        let json = stringData.data(using: .utf8)!
        var artistList: [ArtistViewModel] = []
        do {
            let decoder = JSONDecoder()
            let iTunesArtistModel = try decoder.decode(ITunesArtistModel.self, from: json)
            artistList = iTunesArtistModel.results.map { ArtistViewModel(id: $0.artistId, name: $0.artistName) }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return artistList
    }

}
