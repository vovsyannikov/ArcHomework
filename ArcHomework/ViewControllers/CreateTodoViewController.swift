//
//  CreateTodoViewController.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import UIKit

class CreateTodoViewController: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    var presenter: CreateTodoPresenterInput = CreateTodoPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func save(_ sender: Any) {
        presenter.newTodo(from:
                            nameTextfield.text!.isEmpty ?
                            "Новая задача" :
                            nameTextfield.text!)
        
        dismiss(animated: true, completion: nil)
    }
}
