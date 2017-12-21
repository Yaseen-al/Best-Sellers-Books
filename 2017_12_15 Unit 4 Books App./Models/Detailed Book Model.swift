//
//  Detailed Book Model.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/17/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import Foundation
struct DetailedBookData: Codable {
    // it is only one item in the array as per the JSON file
    let items: [DetailedBook]
}
struct DetailedBook: Codable {
    let id: String?
    let volumeInfo: VolumeInfoWraper
}
struct VolumeInfoWraper: Codable {
    let title: String?
    let publisher: String?
    let description: String?
    let imageLinks: ImageLinksWraper?
    let authors: [String]?
}

struct ImageLinksWraper: Codable {
    let smallThumbnail: String
    let thumbnail: String
}
