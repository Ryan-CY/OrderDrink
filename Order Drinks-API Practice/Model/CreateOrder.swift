//
//  CreateOrder.swift
//  LiHoTea
//
//  Created by Ryan Lin on 2023/6/14.
//

import Foundation

//for upload order infomation of POST
struct CreateOrder: Encodable {
    let records: [Record]
    
    struct Record: Encodable {
        let id: String?
        let fields: OrderDetail
        
        struct OrderDetail: Encodable {
            let name: String
            let size: String
            let sugarLevel: String
            let iceLevel: String
            let toppings: String
            let quantity: Int
            let note: String?
            let time: String
        }
    }
}
//for receive response of POST
struct Response: Decodable {
    let fields: DrinkDetail
    
    struct DrinkDetail: Decodable {
        let name: String
        let size: String
        let sugarLevel: String
        let iceLevel: String
        let toppings: String
        let quantity: Int
        let note: String?
        let time: String
    }
}

