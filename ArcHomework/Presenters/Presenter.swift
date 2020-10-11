//
//  Presenter.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation

protocol PresenterInput {
    var output: PresenterOutput! { get set }
    
    func createToDo()
    func readToDos()
    
}

protocol PresenterOutput {
    func updated(_ indexPath: [IndexPath])
}

class Presenter: PresenterInput{
    
    var output: PresenterOutput!
    
    var interactor: InteractorInput! = Interactor()
    var router: RouterInput! = Router()
    
    func readToDos() {
        interactor.read()
    }
    func createToDo() {
        router.present(CreateTodoViewController())
    }
        
}

extension Presenter: InteractorOutput, RouterOutput{
    func created(_ todo: ToDo) {
        print("\(todo)")
    }
    
    func cleared(_ indexPath: [IndexPath]) {
        output.updated(indexPath)
    }
    
    
}
