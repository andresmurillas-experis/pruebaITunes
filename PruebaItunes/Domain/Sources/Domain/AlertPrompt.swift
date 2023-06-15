//
//  AlertPrompt.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 17/5/23.
//

import Foundation
import UIKit
import Data

protocol AlertPrompt: UIAlertViewDelegate {
    @available(iOS 13.0, *)
    func showError(_ error: WebAPIDataSource.NetworkError?, title: String) -> Void
}

@available(iOS 13.0, *)
extension AlertPrompt where Self: UIViewController {
    typealias NetworkError = WebAPIDataSource.NetworkError
    func showError(_ error: WebAPIDataSource.NetworkError?, title: String) {
        let alertMessage = UIAlertController(title: title, message: error?.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive)
        alertMessage.addAction(okAction)
        self.present(alertMessage, animated: true)
    }
    func classifyError(error: WebAPIDataSource.NetworkError) -> String {
        switch error {
        case .parsing:
            return "Parsing Error"
        case .noData:
            return "No Data Error"
        case .serviceError:
            return "Service Error"
        case .alamofire:
            return "Alamofir Error"
        }
    }
}
