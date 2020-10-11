//
//  Presenter.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation
import UIKit

protocol PresenterInput {
    var output: PresenterOutput! { get set }
    var vc: ViewController! { get set }
    
    func createToDo()
    func readToDos()
    func toggle(_ todo: ToDo)
    func clearCompleted()
}

protocol PresenterOutput {
    func updated(_ indexPath: [IndexPath])
}

class Presenter: PresenterInput{
    var output: PresenterOutput!
    var vc: ViewController!
    
    var interactor: InteractorInput! = Interactor()
    var router: RouterInput! = Router()
    
    func readToDos() {
        interactor.read()
    }
    func createToDo() {
        router.output = self
        router.present(vc, sender: self)
    }
    
    func toggle(_ todo: ToDo) {
        interactor.toggle(todo, for: vc)
    }
    
    func clearCompleted() {
        interactor.output = self
        interactor.clear()
    }
        
}

extension Presenter: InteractorOutput, RouterOutput{
    func created(_ todo: ToDo) {
        interactor.write(todo, for: vc)
    }
    
    func cleared(_ indexPath: [IndexPath]) {
        output.updated(indexPath)
    }
    
    
}
