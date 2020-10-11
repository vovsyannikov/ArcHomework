//
//  Interactor.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation
import RealmSwift

protocol InteractorInput {
    var output: InteractorOutput! { get set }
    
    func read()
    func write(_ todo: ToDo, for vc: ViewController )
    func toggle(_ todo: ToDo, for vc: ViewController)
    func clear()
}

protocol InteractorOutput {
    func cleared(_ indexPath: [IndexPath])
}

class Interactor: InteractorInput{
    var output: InteractorOutput!
    
    private let realm = try! Realm()
    
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
    
    func write(_ todo: ToDo, for vc: ViewController) {
        try! realm.write {
            realm.add(todo)
        }
        switch todo.isActive {
        case true:
            todos.append(todo)
        case false:
            completed.append(todo)
        }
        
        vc.tableView.reloadData()
    }
    
    func toggle(_ todo: ToDo, for vc: ViewController) {
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
    }
    
    func clear() {
        var indexesToDelete: [IndexPath] = []
        
        try! realm.write {
            for (i, todo) in completed.enumerated(){
                indexesToDelete.append(IndexPath(row: i, section: 1))
                realm.delete(todo)
            }
            completed = []
        }
        
        output.cleared(indexesToDelete)
    }
    
    
}

