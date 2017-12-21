//
//  Book Model.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import Foundation
let googleAPIKey = "AIzaSyCHaOQyR-VB5tMXcksCxnU_Sk4MMIv-Ht4"

struct BestSellersData: Codable {
    let results: [BookWraper]
}

struct BookWraper: Codable {
    let listName: String
    let rank: Int
    let bookDetails: [Book]
    let isbns: [IspnWrapper]
    let bestsellersDate: String
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case bookDetails = "book_details"
        case rank
        case isbns
        case bestsellersDate = "bestsellers_date"
    }
}
struct IspnWrapper: Codable {
    let isbn10: String
    let isbn13: String
}
struct Book: Codable {
    let title: String
    let description: String
    let author: String
    let publisher: String?
    let primaryIsbn13: String
    let primaryIsbn10: String
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case author
        case publisher
        case primaryIsbn13 =  "primary_isbn13"
        case primaryIsbn10 = "primary_isbn10"
    }
}
