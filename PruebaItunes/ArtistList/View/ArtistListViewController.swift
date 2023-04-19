//
//  ArtistListViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit

protocol ArtistListViewProtocol: AnyObject {
    func setArtistList(_ artistList: [ArtistModel]?)
}

final class ArtistListViewController: UIViewController {

    private let tableView = UITableView()

    private var presenter: ArtistListPresenterProtocol
    private var searchBar: UISearchBar = UISearchBar()
    var searchText = ""
    private var artistList: [ArtistModel]? = [] {
        didSet {
//            print(artistList)
            DispatchQueue.main.async {
                self.tableView.reloadData() 
            }
        }
    }

    init(presenter: ArtistListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.artistListView = self
        searchBar.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        navigationItem.titleView = searchBar
        setupTableView()
    }

}

private extension ArtistListViewController {
    func setupTableView() {
        view.addSubview(tableView)
        print("mcfly")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(ArtistCell.self, forCellReuseIdentifier:"ArtistCellReuseIdentifier")
        tableView.dataSource = self
    }
}

extension ArtistListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        viewDidLoad()
    }
}

extension ArtistListViewController: ArtistListViewProtocol {
    func setArtistList(_ artistList: [ArtistModel]?) {
        self.artistList = artistList
//        print(self.artistList)
//        print(artistList)
    }
}

extension ArtistListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        artistList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCellReuseIdentifier", for: indexPath) as? ArtistCell else {
            return UITableViewCell()
        }
        guard let artistList = artistList else {
            return ArtistCell()
        }
//        print(artistLi)
        let artist = artistList[indexPath.item]
        cell.setupViewModel(artist)
        cell.viewdidLoad()
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
}

extension ArtistListViewController: OnTapDelegate {
    func didSelectCellWith(artist: ArtistModel) {
        presenter.goToDetailViewForArtist(artist)
    }
}
