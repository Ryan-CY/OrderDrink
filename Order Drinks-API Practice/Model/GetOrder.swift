//
//  GetOrder.swift
//  LiHoTea
//
//  Created by Ryan Lin on 2023/6/13.
//

import Foundation

struct GetOrder: Codable {
  let records: [OrderRecord]
}

struct OrderRecord: Codable {
    let id: String
    let fields: Field
}

struct Field: Codable {
    let size: String
    let sugarLevel: String
    let toppings: String
    let name: String
    let note: String?
    let quantity: Int
    let iceLevel: String
    let time: String
}
