//
//  MenuController.swift
//  CafeApp
//
//  Created by Machir on 2022/8/9.
//

import Foundation

class MenuController {
    
    static let shared = MenuController()
    
    func fetchData(urlStr: String, completion: @escaping (Result<[Cafe], Error>) -> Void) {
        let url = URL(string: urlStr)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let deocder = JSONDecoder()
                do {
                    let cafeResponse = try deocder.decode([Cafe].self, from: data)
                    completion(.success(cafeResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
