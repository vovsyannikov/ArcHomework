//
//  CategoryPresenter.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import Foundation

protocol PresenterInput {
    var output: PresenterOutput! { get set }
    
    func loadCategories()
}

protocol PresenterOutput {
    func updateTableView(with categories: [Category])
}

class CategoryPresenter: PresenterInput {
    var output: PresenterOutput!
    
    var interactor: InteractorInput! = CategoryInteractor()
    
    func loadCategories() {
        interactor.output = self
        interactor.loadCategories()
    }
}

extension CategoryPresenter: InteractorOutput {
    func loaded(_ categories: [Category]) {
        output.updateTableView(with: categories)
    }
}
