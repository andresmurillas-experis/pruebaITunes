//
//  CollectionViewCell.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/3/23.
//

import UIKit
import Domain

final class AlbumCell: UIView {
    weak private var delegate: UIStackView?
    lazy private var albumTitle: UILabel = {
        var title = UILabel(frame: CGRect.zero)
        title.text = ""
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 16).isActive = true
        title.widthAnchor.constraint(equalToConstant: 110).isActive = true
        title.textColor = .white
        return title
    }()
    lazy private var albumCover: UIImageView = {
        var cover = UIImageView(image: UIImage(systemName: "music.note.list"))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.heightAnchor.constraint(equalToConstant: 115).isActive = true
        cover.widthAnchor.constraint(equalToConstant: 115).isActive = true
        return cover
    }()
    var dataTask: URLSessionDataTask?
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewDidLoad()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AlbumCell {
    func setupViewModel(_ viewModel: AlbumEntity) {
        downloadAlbumCover(from: viewModel.albumCoverLarge ?? "") { result in
            switch result {
            case .success(let image):
                self.albumCover.image = image
                self.albumTitle.text = viewModel.albumName
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
        self.addSubview(albumCover)
        albumCover.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        albumCover.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumCover.contentMode = .scaleAspectFit
        albumCover.updateConstraints()
        self.addSubview(albumTitle)
        albumTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        albumTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8  ).isActive = true
        albumTitle.contentMode = .scaleAspectFit
        albumTitle.updateConstraints()
    }
    func wipeCover() {
        self.albumCover.image = nil
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
