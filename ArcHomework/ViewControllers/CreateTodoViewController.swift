//
//  CreateTodoViewController.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import UIKit

protocol CreateTodoDelegate{
    func created(_ todo: ToDo)
}

class CreateTodoViewController: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    var delegate: CreateTodoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func save(_ sender: Any) {
        let todo = ToDo(task: nameTextfield.text!.isEmpty ? "Новая задача" : nameTextfield.text!, isActive: true)
        
        self.delegate?.created(todo)
        dismiss(animated: true, completion: nil)
    }
}
