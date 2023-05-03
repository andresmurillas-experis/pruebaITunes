//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit

final class ArtistDetailViewController: UIViewController {
    lazy private var mainStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    lazy private var rowStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return stackView
    }()
    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainStackView)
        scrollView.addConstraint(mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor))
        scrollView.addConstraint(mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor))
        scrollView.addConstraint(mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor))
        scrollView.addConstraint(mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor))
        scrollView.addConstraint(mainStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor))
        scrollView.addConstraint(mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor))
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    private var vm: ArtistDetailViewModel
    private var albumList: [AlbumModel] = [] {
        didSet {
            let albumViewCell = AlbumCell(frame: CGRect.zero)
            let albumViewCell2 = AlbumCell(frame: CGRect.zero)

            let stackView = UIStackView()
            view.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            stackView.heightAnchor.constraint(equalToConstant: 175).isActive = true
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            stackView.backgroundColor = .brown
            stackView.contentMode = .scaleAspectFit
            albumViewCell.translatesAutoresizingMaskIntoConstraints = false
            albumViewCell.setupViewModel(albumList[0])
            albumViewCell2.translatesAutoresizingMaskIntoConstraints = false
            albumViewCell2.setupViewModel(albumList[1])
            stackView.addArrangedSubview(albumViewCell)
            stackView.addArrangedSubview(albumViewCell2)
//            albumViewCell.translatesAutoresizingMaskIntoConstraints = false
//            albumViewCell.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
//            albumViewCell.contentMode = .scaleAspectFit
//            albumViewCell2.translatesAutoresizingMaskIntoConstraints = false
//            albumViewCell2.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
//            albumViewCell2.contentMode = .scaleAspectFit
            stackView.updateConstraints()
        }
    }
    init(vm: ArtistDetailViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        vm.albumListBinding.bind { (albumList) in
            self.albumList = albumList
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad()
    }
}

private extension ArtistDetailViewController { }

extension ArtistDetailViewController {
    func setAlbumList(_ albumList: [AlbumModel]) {
        self.albumList = albumList
    }
}
