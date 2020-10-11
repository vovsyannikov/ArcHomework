//
//  Router.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation
import UIKit

protocol RouterInput {
    var output: RouterOutput! { get set }
    
    func present(_ vc: UIViewController, sender: PresenterInput)
    func createdNew(_ todo: ToDo)
}

protocol RouterOutput {
    func created(_ todo: ToDo)
}

class Router: RouterInput{
    var output: RouterOutput!
    
    func present(_ vc: UIViewController, sender: PresenterInput) {
        let createVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CreateToDo") as! CreateTodoViewController
        
        let newPresenter = createVC.presenter as! CreateTodoPresenter
        newPresenter.router.output = sender as! Presenter
        
        vc.present(createVC, animated: true) { createVC.viewDidLoad() }
    }
    
    func createdNew(_ todo: ToDo) {
        output.created(todo)
    }
    
}
