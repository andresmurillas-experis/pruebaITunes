//
//  AlertPrompt.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 17/5/23.
//

import Foundation
import UIKit

protocol AlertPrompt: UIAlertViewDelegate {
    @available(iOS 13.0, *)
    func showError(_ error: WebAPIDataSource.NetworkError?, title: String) -> Void
}

extension AlertPrompt where Self: UIViewController {
    @available(iOS 13.0, *)
    func showError(_ error: WebAPIDataSource.NetworkError?, title: String) {
        let alertMessage = UIAlertController(title: title, message: error?.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive)
        alertMessage.addAction(okAction)
        self.present(alertMessage, animated: true)
    }
}
