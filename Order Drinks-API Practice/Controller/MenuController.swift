//
//  StoreItemsController.swift
//  Order Drinks-API Practice
//
//  Created by Ryan Lin on 2023/6/13.
//

import Foundation
import UIKit

class MenuController {
    
    static let shared = MenuController()
    private let apiValue = "Bearer keyKBO0vQ1IDXoi8R"
    
    func fetchMenu(urlString: String, completion: @escaping (Result<[Record], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        request.setValue(apiValue, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
            } else if let data {
                let decoder = JSONDecoder()
                do {
                    let getMenu = try decoder.decode(GetMenu.self, from: data)
                    completion(.success(getMenu.records))
                    print("⭐️ success")
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    enum MenuItemError: Error, LocalizedError {
        case imageDataMissing
    }
    
    func fetchImage(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
            } else if let data,
                      let photo = UIImage(data: data) {
                completion(.success(photo))
            } else {
                completion(.failure(MenuItemError.imageDataMissing))
            }
        }.resume()
    }
    
}
