//
//  ArtistDetailPresenter.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 14/3/23.
//

import Foundation
import UIKit

class ArtistDetailPresenter: ArtistDetailPresenterProtocol {

    weak private var artistDetailViewDelegate: ArtistDetailViewDelegate?

    var dataTask: URLSessionDataTask?

    func setviewdelegate(artistDetailViewDelegate: ArtistDetailViewDelegate?) {
        self.artistDetailViewDelegate = artistDetailViewDelegate
    }

}

extension ArtistDetailPresenter {

    enum NetworkError: Error {
        case serviceError, noData, parsing
    }

    func downloadFromITunes(from url: String, completionHandler: @escaping (Result<[AlbumViewModel], NetworkError>) -> Void) {
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

    func download(url: String) {

        downloadFromITunes(from: url, completionHandler: { [weak self] result in
               switch result {
               case .success(let albumList):
                   self?.artistDetailViewDelegate?.setAlbumList(albumList)
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
        })

    }

}
