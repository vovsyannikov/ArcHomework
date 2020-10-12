//
//  ViewController.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import UIKit
import RealmSwift


//MARK: ViewController
class ViewController: UIViewController {
    
    let viewModel = ToDoViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clear(_ sender: Any) {
        viewModel.clearCompleted() { [weak self] indexesToDelete in  self?.tableView.deleteRows(at: indexesToDelete, with: .automatic) }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateTodoViewController, segue.identifier == "CreateToDo"{
            vc.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.read()
        
    }
    
}

//MARK: UITableView extensions
extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Активные" : "Завершенные"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.todos.count : viewModel.completed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDo") as! ToDoTableViewCell
        
        let todo = indexPath.section == 0 ? viewModel.todos[indexPath.row] : viewModel.completed[indexPath.row]
        
        cell.nameLabel.attributedText = todo.attributedTask
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todo = indexPath.section == 0 ? viewModel.todos[indexPath.row] : viewModel.completed[indexPath.row]
        viewModel.toggle(todo) { [weak self] in self?.tableView.reloadSections(IndexSet(0...1), with: .automatic) }
    }
}

extension ViewController: CreateTodoDelegate {
    func created(_ todo: ToDo) {
        viewModel.write(todo) { [weak self] in self?.tableView.reloadData() }
    }
}
