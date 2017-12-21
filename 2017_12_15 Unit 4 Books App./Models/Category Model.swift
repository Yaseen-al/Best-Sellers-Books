//
//  Category Model.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import Foundation
struct CategoryData: Codable {
    let results: [Category]
}
struct Category: Codable {
    let listName: String
    let displayName: String
    let listNameEncoded: String
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
    }
}
