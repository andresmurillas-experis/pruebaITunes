//
//  CellTableView.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/2/23.
//

import UIKit

protocol OnTapDelegate: AnyObject {
    func didSelectCell(artist: ArtistViewModel)
}

final class ArtistCell: UITableViewCell {

    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var discOneName: UILabel!
    @IBOutlet private weak var discTwoName: UILabel!
    @IBOutlet private weak var moreContentExistsIndicator: UILabel!

    weak var delegate: OnTapDelegate?

    override func awakeFromNib() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.cellTapped))
        addGestureRecognizer(tapGestureRecognizer)
    }

    override func prepareForReuse() {
        name.text = ""
        discOneName.text = ""
        discTwoName.text = ""
    }

    @objc func cellTapped() {
        guard let name = self.name.text else {
            return
        }
        let discOneName = discOneName.text ?? ""
        let discTwoName = discTwoName.text ?? ""
        delegate?.didSelectCell(artist: ArtistViewModel(name: name, discOneName: discOneName, discTwoName: discTwoName))
    }

    func setupViewModel(_ viewModel: ArtistViewModel) {
        self.name.text = viewModel.name
        self.discOneName.text = viewModel.discOneName
        self.discTwoName.text = viewModel.discTwoName
        moreContentExistsIndicator.isHidden = true
        self.discOneName.isHidden = true
        self.discTwoName.isHidden = true
    }

}
