//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit
import Combine

final class ArtistDetailViewController: UIViewController, AlertPrompt {
    private var cancellables = [AnyCancellable]()
    lazy private var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    lazy private var contentView: UIView = {
        var contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    lazy private var mainStackView: UIStackView = {
        var mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        return mainStackView
    }()
    private var vm: ArtistDetailViewModel
    private var albumList: [AlbumEntity] = [] {
        didSet {
            setupCollectionView()
        }
    }
    private var error: WebAPIDataSource.NetworkError? {
        didSet {
            switch error {
            case .serviceError:
                showError(error, title: "Service, Error")
            case .noData:
                showError(error, title: "No Data Error")
            case .parsing:
                showError(error, title: "Parsing Error")
            case .alamofire:
                showError(error, title: "Alamofire Error")
            case .none:
                return
            }
        }
    }
    init(vm: ArtistDetailViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.vm.subject.sink( receiveCompletion: { [weak self] (completion) in
            switch completion {
            case .failure(let error):
                switch error {
                case .noData:
                    self?.showError(error, title: "No Data Error")
                    return
                case .parsing:
                    self?.showError(error, title: "Parsing Error")
                    return
                case .serviceError:
                    self?.showError(error, title: "Service Error")
                    return
                case .alamofire:
                    self?.showError(error, title: "Alamofire Error")
                    return
                }
            case .finished:
                print("Succesfully finished washing my boat")
            }
        }, receiveValue: { [weak self] (albumList) in
            self?.albumList = albumList
        }).store(in: &cancellables)
        self.vm.viewDidLoad()
    }
}

private extension ArtistDetailViewController {
    func divideInChunks(array: [AlbumCell]) {
        return
    }
    func setupCollectionView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.showsVerticalScrollIndicator = true

        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        contentView.addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        contentView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor).isActive = true

        // Split albumList into chunks.
        let chunks = stride(from: 0, to: albumList.count, by: 3).map { i in
            var chunk: [AlbumEntity] = []
            if i < (albumList.count - 3) {
                for j in  i...(i + 2) {
                    chunk.append(albumList[j])
                }
            } else {
                for j in (i...albumList.count - 1) {
                    chunk.append(albumList[j])
                }
            }
            return chunk
        }
        var rows: [UIStackView] = []
        for _ in 0...chunks.count {
            rows.append(UIStackView())
        }
        // Populate the main stackview with rows and populate these with the created chunks.
        var i = 0
        for chunk in chunks {
            mainStackView.addArrangedSubview(rows[i])
            rows[i].translatesAutoresizingMaskIntoConstraints = false
            rows[i].heightAnchor.constraint(equalToConstant: 120).isActive = true
            rows[i].distribution = .fillEqually
            var newchunk = chunk
            // Make chunks null pointer safe for populating rows.
            if chunk.count < 3 {
                for _ in chunk.count...2 {
                    newchunk.append(AlbumEntity(albumName: nil, albumCover: nil, albumCoverLarge: nil))
                }
            }
            for album in newchunk {
                let albumViewCell = AlbumCell(frame: CGRect.zero)
                albumViewCell.setupViewModel(album)
                if album.albumName == nil {
                    albumViewCell.wipeCover()
                }
                rows[i].addArrangedSubview(albumViewCell)
                rows[i].reloadInputViews()
            }
            i += 1
        }
        mainStackView.reloadInputViews()
    }
}

extension ArtistDetailViewController {
    func setAlbumList(_ albumList: [AlbumEntity]) {
        self.albumList = albumList
    }
}
