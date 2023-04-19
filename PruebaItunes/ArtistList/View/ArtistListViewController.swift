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

    @IBOutlet private weak var tableView: UITableView!

    private var vm: ArtistListPresenterProtocol
    private var searchBar: UISearchBar = UISearchBar()
    var searchText = ""
    private var artistList: [ArtistModel]? = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, presenter: ArtistListPresenterProtocol) {
        self.vm = presenter
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        presenter.artistListView = self
        searchBar.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.viewDidLoad()
        navigationItem.titleView = searchBar
        setTableView()
    }

}

private extension ArtistListViewController {
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(ArtistCell.self, forCellReuseIdentifier: "ArtistCellReuseIdentifier")
        
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
//        print(artistList?.count)
//        print(artistList?.last?.name)
//        print(artistList?.last?.discTwoName)
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
        let artist = artistList[indexPath.item]
        cell.setupViewModel(artist)
//        print(artist.discTwoName)
        cell.viewdidLoad()
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        62
    }
}

extension ArtistListViewController: OnTapDelegate {
    func didSelectCellWith(artist: ArtistModel) {
        vm.goToDetailViewForArtist(artist)
    }
}
