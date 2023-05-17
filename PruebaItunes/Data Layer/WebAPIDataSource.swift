//
//  DownloadClient.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 23/3/23.
//

import Foundation

final class WebAPIDataSource {
    enum NetworkError: Error {
        case serviceError, noData, parsing
    }
    func download <ResultType: Decodable>(from url: String, completionHandler: @escaping (Result<ResultType , NetworkError>) -> ()) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        print(url)
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(.failure(NetworkError.serviceError))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            guard let iTunesResult: ResultType = self.decodeJsonFromData(data) else {
                completionHandler(.failure(NetworkError.parsing))
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success(iTunesResult))
            }
        }.resume()
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
