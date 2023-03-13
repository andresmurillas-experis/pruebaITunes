//
//  CollectionViewCell.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/3/23.
//

import UIKit

final class AlbumViewCell: UICollectionViewCell {

    @IBOutlet private var albumName: UILabel!
    @IBOutlet private var albumCover: UIImageView!

    var dataTask: URLSessionDataTask?

    var image: UIImage! {
        didSet {
            albumCover = UIImageView(image: image)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupViewModel(_ viewModel: AlbumViewModel) {
        albumName.text = viewModel.albumName
        downloadAlbumCover(from: viewModel.albumCover ?? "") { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image ?? UIImage()
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

private extension AlbumViewCell {

    enum NetworkError: Error {
        case serviceError, noData, parsing
    }

    func downloadAlbumCover(from url: String, completionHandler: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        dataTask?.cancel()
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(.failure(NetworkError.serviceError))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completionHandler(.success(image))
            }
        }.resume()
    }

}
