//
//  Book API Client.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import Foundation
struct BookAPIClient {
    private init() {}
    static let manager = BookAPIClient()
    func getBooks(for searchCategory: String, completionHandler: @escaping ([BookWraper]) -> Void, errorHandler: @escaping (AppError) -> Void) {
        let apiKey =  "fc9bfdf440f74afc80ca0015d1604607"
        let urlStr = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(apiKey)&list=\(searchCategory)"
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let results = try JSONDecoder().decode(BestSellersData.self, from: data)
                completionHandler(results.results)
            }
            catch {
                errorHandler(.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: {print($0)})
    }
}
