//
//  StoreItem.swift
//  Order Drinks-API Practice
//
//  Created by Ryan Lin on 2023/6/4.
//

import Foundation

struct GetMenu: Codable {
    let records: [Record]
}

struct Record: Codable {
    let fields: Detail
}
struct Detail: Codable {
    let image: [Photo]
    let price: Double
    let name: String
    let category: [String]
}
struct Photo: Codable {
    let url: URL
}
