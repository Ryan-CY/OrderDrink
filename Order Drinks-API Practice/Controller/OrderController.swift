//
//  OrderController.swift
//  LiHoTea
//
//  Created by Ryan Lin on 2023/6/13.
//

import Foundation

class OrderController {
    
    static let shared = OrderController()
    
    private let apiValue = "Bearer keyKBO0vQ1IDXoi8R"
    
    func fetchOrderList(comletion: @escaping (Result<[OrderRecord], Error>) -> Void) {
        
        guard let url = URL(string: "https://api.airtable.com/v0/appBBoJvZRrxzj09q/Order?sort[][field]=time&sort[][direction]=desc") else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"     //http Method
        request.setValue(apiValue, forHTTPHeaderField: "Authorization")     //http Header
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error {
                comletion(.failure(error))
            } else if let data {
                do {
                    let decoder = JSONDecoder()
                    let getOrder = try decoder.decode(GetOrder.self, from: data)
                    comletion(.success(getOrder.records))
                } catch {
                    comletion(.failure(error))
                }
            }
        }.resume()
    }
    
    func postOrder(createOrder: CreateOrder.Record, completion: @escaping (Result<Response, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.airtable.com/v0/appBBoJvZRrxzj09q/Order") else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"   //http Method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")   //http Header
        request.setValue(apiValue, forHTTPHeaderField: "Authorization")     //http Header
        
        let newOrder = createOrder
        
        let encoder = JSONEncoder()
        
        let uploadData = try? encoder.encode(newOrder) //encode the new order will be uploaded
        
        request.httpBody = uploadData     //http Body
        /*
         if let uploadData,
         let content = String(data: uploadData, encoding: .utf8) {
         print("🔵uploadData",content)   //check the data that will be uploaded
         }
         */
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error {
                completion(.failure(error))
            } else if let data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)
                    completion(.success(response))
                    //print("⭐️data(Post)",String(data: data, encoding: .utf8)!)
                    //print("🟢response(Post)",response)
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func deleteOrder(deleteID: String) {
        
        guard let url = URL(string: "https://api.airtable.com/v0/appBBoJvZRrxzj09q/Order/\(deleteID)") else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"     //http Method
        request.setValue(apiValue, forHTTPHeaderField: "Authorization")     //http Header
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("🟡httpResponse.statusCode", httpResponse.statusCode)
            }
            if let data {
                print("🟢content",String(data: data, encoding: .utf8)!)
            }
        }.resume()
    }
}
