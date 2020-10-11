//
//  CreateTodoPresenter.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 11.10.2020.
//

import Foundation

protocol CreateTodoPresenterInput{
    var output: CreateTodoPresenterOutput! { get set }
    
    func newTodo(from name: String)
}

protocol CreateTodoPresenterOutput{
    func created(_ todo: ToDo)
}

class CreateTodoPresenter: CreateTodoPresenterInput{
    
    var output: CreateTodoPresenterOutput!
    
    var router: RouterInput! = Router()
    
    func newTodo(from name: String) {
        let todo = ToDo(task: name, isActive: true)
        router.createdNew(todo)
    }
}

