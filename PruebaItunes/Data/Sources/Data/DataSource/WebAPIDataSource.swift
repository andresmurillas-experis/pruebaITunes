//
//  DownloadClient.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/3/23.
//

import Foundation
import Alamofire
import Combine

public final class WebAPIDataSource {
    public enum NetworkError: Error {
        case serviceError, noData, parsing, alamofire
    }
     func download <DecodableType: Decodable>(from url: String) -> AnyPublisher<DecodableType, WebAPIDataSource.NetworkError> {
         guard let url = URL(string: url) else {
             print("Invalid URL")
             return Fail(error: WebAPIDataSource.NetworkError.serviceError).eraseToAnyPublisher()
         }
         let alamofire: AnyPublisher<DecodableType, WebAPIDataSource.NetworkError> = AF
             .request(url)
             .publishDecodable(type: DecodableType.self)
             .value()
             .mapError({ error in
                     .alamofire
             })
             .eraseToAnyPublisher()
         return alamofire
    }
}

private extension WebAPIDataSource {
    func decodeJsonFromData<ViewModelObject: Decodable>(_ data: Data) -> ViewModelObject? {
        let stringData = String(data: data, encoding: .utf8)!
        let json = stringData.data(using: .utf8)!
        let decoder = JSONDecoder()
        var iTunesResultObject: ViewModelObject?
        do {
            iTunesResultObject = try decoder.decode(ViewModelObject.self, from: json)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return iTunesResultObject
    }
}
