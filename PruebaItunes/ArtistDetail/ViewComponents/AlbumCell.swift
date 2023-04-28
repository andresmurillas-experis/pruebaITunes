//
//  CollectionViewCell.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/3/23.
//

import UIKit

final class AlbumCell: UIView {
    private var albumName = UILabel()
    weak private var delegate: UIStackView?
    private var albumCover: UIImageView = UIImageView(image: UIImage(systemName: "music.note.list"))
    var dataTask: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlbumCell {
    func setupViewModel(_ viewModel: AlbumModel, parent: UIStackView) {
        albumName.text = viewModel.albumName
        downloadAlbumCover(from: viewModel.albumCoverLarge ?? "") { result in
            switch result {
            case .success(let image):
                self.albumCover.image = image
                self.viewDidLoad()
                parent.addArrangedSubview(self)
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
    func viewDidLoad() {
        self.addSubview(albumName)
        self.addSubview(albumCover)
        albumCover.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(albumCover.heightAnchor.constraint(equalToConstant: 175))
        addConstraint(albumCover.widthAnchor.constraint(equalTo: widthAnchor))
        addConstraint(albumCover.centerXAnchor.constraint(equalTo: centerXAnchor))
        addConstraint(albumCover.centerYAnchor.constraint(equalTo: centerYAnchor))
        albumCover.updateConstraints()
    }
}

private extension AlbumCell {
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
