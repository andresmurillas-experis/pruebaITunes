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
        stackView   .setContentHuggingPriority(.defaultHigh, for: .vertical)
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
            setupStackView()
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

private extension ArtistDetailViewController {
    func setupStackView() {
        view.addSubview(scrollView)
        view.addConstraint(scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100))
        view.addConstraint(scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        view.addConstraint(scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        view.addConstraint(scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        for album in albumList {
            let albumView = AlbumCell(frame: CGRect.zero)
            albumView.translatesAutoresizingMaskIntoConstraints = false
            let rowStack = UIStackView()
            mainStackView.addArrangedSubview(rowStack)
            albumView.setupViewModel(album, parent: rowStack)
        }
    }
}

extension ArtistDetailViewController {
    func setAlbumList(_ albumList: [AlbumModel]) {
        self.albumList = albumList
    }
}
