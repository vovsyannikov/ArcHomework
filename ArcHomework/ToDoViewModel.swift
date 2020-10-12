//
//  ToDoViewModel.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 12.10.2020.
//

import Foundation
import RealmSwift


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
