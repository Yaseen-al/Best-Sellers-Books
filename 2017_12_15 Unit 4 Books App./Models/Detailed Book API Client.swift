//
//  Detailed Book API Client.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/17/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import Foundation

struct DetailedBookAPIClient {
    private init() {}
    static let manager = DetailedBookAPIClient()
    func getDetaildBookUsingTitle(book: Book, completionHandler: @escaping ([DetailedBook]) -> Void, errorHandler: @escaping (AppError) -> Void) {
        let apiKey =  "AIzaSyAKIKVu20jAGAtUMsM-1zbwMLVh2pdvIrs"
        let myQ = book.title.lowercased().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        let author = book.author.lowercased().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        let urlStr = "https://www.googleapis.com/books/v1/volumes?key=\(apiKey)&q=\(myQ)+intitle:\(myQ)+inauthor:\(author)"
        print(urlStr)
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL)
            print(urlStr)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let results = try JSONDecoder().decode(DetailedBookData.self, from: data)
                completionHandler(results.items)
            }
            catch {
                errorHandler(.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: {print($0)})
    }
    func getDetaildBookUsingIsbn(book: Book, completionHandler: @escaping ([DetailedBook]) -> Void, errorHandler: @escaping (AppError) -> Void) {
        let apiKey =  "AIzaSyAKIKVu20jAGAtUMsM-1zbwMLVh2pdvIrs"
        let myQ = book.title.lowercased().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        let author = book.author.lowercased().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        let urlStr = "https://www.googleapis.com/books/v1/volumes?key=\(apiKey)&q=\(myQ)+intitle:\(myQ)+inauthor:\(author)"
        let urlStr2 =  "https://www.googleapis.com/books/v1/volumes?key=\(apiKey)&q=isbn:\(book.primaryIsbn13)"
        guard let url = URL(string: urlStr2) else {
            errorHandler(.badURL)
            print(urlStr)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let results = try JSONDecoder().decode(DetailedBookData.self, from: data)
                completionHandler(results.items)
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
