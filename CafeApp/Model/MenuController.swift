//
//  MenuController.swift
//  CafeApp
//
//  Created by Machir on 2022/8/9.
//

import Foundation

class MenuController {
    
    static let shared = MenuController()
    
    let taipei = City(name: "雙北", api: "https://cafenomad.tw/api/v1.2/cafes/taipei")
    let keelung = City(name: "基隆", api: "https://cafenomad.tw/api/v1.2/cafes/keelung")
    let taoyuan = City(name: "桃園", api: "https://cafenomad.tw/api/v1.2/cafes/taoyuan")
    let hsinchu = City(name: "新竹", api: "https://cafenomad.tw/api/v1.2/cafes/hsinchu")
    let miaoli = City(name: "苗栗", api: "https://cafenomad.tw/api/v1.2/cafes/miaoli")
    let taichung = City(name: "台中", api: "https://cafenomad.tw/api/v1.2/cafes/taichung")
    let nantou = City(name: "南投", api: "https://cafenomad.tw/api/v1.2/cafes/nantou")
    let changhua = City(name: "彰化", api: "https://cafenomad.tw/api/v1.2/cafes/changhua")
    let yunlin = City(name: "雲林", api: "https://cafenomad.tw/api/v1.2/cafes/yunlin")
    let chiayi = City(name: "嘉義", api: "https://cafenomad.tw/api/v1.2/cafes/chiayi")
    let tainan = City(name: "台南", api: "https://cafenomad.tw/api/v1.2/cafes/tainan")
    let kaohsiung = City(name: "高雄", api: "https://cafenomad.tw/api/v1.2/cafes/kaohsiung")
    let pingtung = City(name: "屏東", api: "https://cafenomad.tw/api/v1.2/cafes/pingtung")
    let yilan = City(name: "宜蘭", api: "https://cafenomad.tw/api/v1.2/cafes/yilan")
    let hualien = City(name: "花蓮", api: "https://cafenomad.tw/api/v1.2/cafes/hualien")
    let taitung = City(name: "台東", api: "https://cafenomad.tw/api/v1.2/cafes/taitung")
    let penghu = City(name: "澎湖", api: "https://cafenomad.tw/api/v1.2/cafes/penghu")
    let lienchiang = City(name: "連江", api: "https://cafenomad.tw/api/v1.2/cafes/lienchiang")
    
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
