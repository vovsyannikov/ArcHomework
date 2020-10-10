//
//  CategoryInteractor.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation

protocol InteractorInput {
    var output: InteractorOutput! { get set }
    
    func loadCategories()
}

protocol InteractorOutput {
    func loaded(_ categories: [Category])
}

class CategoryInteractor: InteractorInput {
   var output: InteractorOutput!
    
    func loadCategories() {
        var categories = [Category]()
        
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let jsonDict = json as? NSDictionary {
//                print(jsonDict)
                for (_, data) in jsonDict where data is NSDictionary {
                    if let category = Category(data: data as! NSDictionary) {
                        categories.append(category)
                    }
                }
                DispatchQueue.main.async {
                    self.output.loaded(categories)
                }
            }
        }
        task.resume()
    }
}
