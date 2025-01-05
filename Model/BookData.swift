//
//  BookData.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation

struct Book: Codable {
    let title: String
    let author: String
    let price: Int
    let thumbnailURL: String
    let description: String
}
