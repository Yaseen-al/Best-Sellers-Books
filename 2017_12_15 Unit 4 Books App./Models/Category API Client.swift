//
//  Category API Client.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import Foundation
struct CategoryAPIClient {
    private init() {}
    static let manager = CategoryAPIClient()
    func getCategories(for searchTerm: String, completionHandler: @escaping ([Category]) -> Void, errorHandler: @escaping (AppError) -> Void) {
        let apiKey =  "fc9bfdf440f74afc80ca0015d1604607"
        let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(apiKey)"
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let results = try JSONDecoder().decode(CategoryData.self, from: data)
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
