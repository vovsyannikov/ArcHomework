//
//  ToDoViewModel.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 12.10.2020.
//

import Foundation
import RealmSwift
import UIKit

class ToDoViewModel{
    let realm = try! Realm()
    
    var todos = [ToDo]()
    var completed = [ToDo]()
    
    //MARK: Realm funcs
    func read() {
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
    
    func write(_ todo: ToDo, completion: @escaping ( () -> Void ) ) {
        try! realm.write {
            realm.add(todo)
        }
        switch todo.isActive {
        case true:
            todos.append(todo)
        case false:
            completed.append(todo)
        }
        
        completion()
    }
    
    func toggle(_ todo: ToDo, completion: @escaping ( () -> Void )){
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
        
        read()
        completion()
    }
    
    func clearCompleted(completion: @escaping ( ([IndexPath]) -> Void ) ) {
        var indexesToDelete: [IndexPath] = []
        
        try! realm.write {
            for (i, todo) in completed.enumerated(){
                indexesToDelete.append(IndexPath(row: i, section: 1))
                realm.delete(todo)
            }
            completed = []
        }
        
        completion(indexesToDelete)
    }
}
