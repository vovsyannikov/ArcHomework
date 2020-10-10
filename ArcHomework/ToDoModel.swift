//
//  ToDo.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation
import RealmSwift

var todos = [ToDo]()
var completed = [ToDo]()

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

//MARK: Realm funcs
func read(from realm: Realm) {
    todos = []
    completed = []
    
    for ob in realm.objects(ToDo.self) {
        switch  ob.isActive {
        case true:
            todos.append(ob)
        case false:
            completed.append(ob)
        }
    }
}

func write(_ todo: ToDo, to realm: Realm) {
    try! realm.write {
        realm.add(todo)
    }
    switch todo.isActive {
    case true:
        todos.append(todo)
    case false:
        completed.append(todo)
    }
}

//ToDo isActive toggle
func toggle(_ todo: ToDo, from realm: Realm){
    try! realm.write {
        var indexToModify: Int!
        for (i, obj) in realm.objects(ToDo.self).enumerated() {
            if obj == todo {
                indexToModify = i
                break
            }
        }
        realm.objects(ToDo.self)[indexToModify].isActive.toggle()
    }
    
    read(from: realm)
}

func clearCompleted(from realm: Realm) -> [IndexPath]{
    var indexesToDelete: [IndexPath] = []
    
    try! realm.write {
        for (i, todo) in completed.enumerated(){
            indexesToDelete.append(IndexPath(row: i, section: 1))
            realm.delete(todo)
        }
        completed = []
    }
    
    return indexesToDelete
}
