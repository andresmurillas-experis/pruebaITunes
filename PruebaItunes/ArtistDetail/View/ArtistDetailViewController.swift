//
//  ArtistDetailViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 3/3/23.
//

import UIKit

final class ArtistDetailViewController: UIViewController {
    private var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())

    private var vm: ArtistDetailViewModel
    private var albumList: [AlbumModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    init(vm: ArtistDetailViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
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
        setupCollectionView()
    }
}

private extension ArtistDetailViewController {
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .brown
        view.addConstraint(collectionView.topAnchor.constraint(equalTo: view.topAnchor))
        view.addConstraint(collectionView.leftAnchor.constraint(equalTo: view.leftAnchor))
        view.addConstraint( collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        view.addConstraint(collectionView.rightAnchor.constraint(equalTo: view.rightAnchor))
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier:"AlbumCellReuseIdentifier")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ArtistDetailViewController {
    func setAlbumList(_ albumList: [AlbumModel]) {
        self.albumList = albumList
    }
}

extension ArtistDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("the time machine")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCellReuseIdentifier", for: indexPath) as? AlbumCell else {
            return UICollectionViewCell()
        }
        cell.setupViewModel(albumList[indexPath.item])
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: 175, height: 175)
//    }
}
