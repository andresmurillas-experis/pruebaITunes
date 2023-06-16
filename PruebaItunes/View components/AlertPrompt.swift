//
//  AlertPrompt.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 17/5/23.
//

import Foundation
import UIKit
import Domain

protocol AlertPrompt: UIAlertViewDelegate {
    func showError(_ error: NetworkError?, title: String) -> Void
}

extension AlertPrompt where Self: UIViewController {
    func showError(_ error: NetworkError?, title: String) {
        let alertMessage = UIAlertController(title: title, message: error?.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive)
        alertMessage.addAction(okAction)
        self.present(alertMessage, animated: true)
    }
}
