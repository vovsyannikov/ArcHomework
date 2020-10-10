//
//  BSWModel.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation
import UIKit

enum CategoryElements: String{
    case name
    case sortOrder
    case imageURL
}

struct Category {
    let imageURL: String
    let name: String
    let sortOrder: Int
    
    init?(data: NSDictionary) {
        guard let name = data[CategoryElements.name.rawValue] as? String,
              let sortOrder = data[CategoryElements.sortOrder.rawValue] as? String,
        let imageURL = data[CategoryElements.imageURL.rawValue] as? String else {
            return nil
        }
        
        self.name = name
        self.sortOrder = Int(sortOrder) ?? 0
        self.imageURL = imageURL
    }
}

class BSWModel{
    var categories = [Category]()
    
    func loadCategories(){
        
    }
}

