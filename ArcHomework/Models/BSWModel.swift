//
//  BSWModel.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation
import UIKit
import SVProgressHUD

struct Category {
    let imageURL: String
    let name: String
    
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
        let imageURL = data["image"] as? String else {
            return nil
        }
        
        self.name = name
        self.imageURL = imageURL
    }
}

class BSWModel{
    var categories = [Category]()
    
    func loadCategories(completion: @escaping () -> Void){
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let jsonDict = json as? NSDictionary {
                print(jsonDict)
                for (key, data) in jsonDict where data is NSDictionary {
                    print(key, data)
                    if let category = Category(data: data as! NSDictionary) {
                        self.categories.append(category)
                    }
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
        task.resume()
    }
}

