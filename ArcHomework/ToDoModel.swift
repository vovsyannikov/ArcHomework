//
//  ToDo.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation
import RealmSwift

class ToDo: Object{
    @objc dynamic var isActive: Bool
    @objc dynamic var task: String
    var attributedTask: NSAttributedString {
        isActive
            ? fixedText(from: task)
            : strikethroughText(from: task)
    }
    
    required init(task: String, isActive: Bool) {
        self.task = task
        self.isActive = isActive
    }
    
    required init() {
        
        self.task = ""
        self.isActive = true
    }
    
    static func == (left: ToDo, right: ToDo) -> Bool {
        return left.task == right.task && left.isActive == right.isActive
    }
    
    func strikethroughText(from input: String) -> NSAttributedString {
        let strikethroughAttribute = [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue]
        let resultingString = NSAttributedString(string: input, attributes: strikethroughAttribute)
        
        return resultingString
    }
    
    func fixedText(from input: String) -> NSAttributedString {
        let result = NSAttributedString(string: input)
        
        return result
    }
}
