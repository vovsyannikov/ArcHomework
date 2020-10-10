//
//  Category.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation

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
