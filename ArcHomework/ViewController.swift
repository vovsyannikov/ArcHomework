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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clear(_ sender: Any) {
        let indexesToDelete = clearCompleted(from: realm)
        self.tableView.deleteRows(at: indexesToDelete, with: .automatic)
    }
    
    let realm = try! Realm()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateTodoViewController, segue.identifier == "CreateToDo"{
            vc.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        testTodos()
        read(from: realm)
        
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
        return section == 0 ? todos.count : completed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDo") as! ToDoTableViewCell
        
        let todo = indexPath.section == 0 ? todos[indexPath.row] : completed[indexPath.row]
        
        cell.nameLabel.attributedText = todo.attributedTask
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todo = indexPath.section == 0 ? todos[indexPath.row] : completed[indexPath.row]
        toggle(todo, from: realm)
        self.tableView.reloadSections(IndexSet(0...1), with: .automatic)
    }
}

extension ViewController: CreateTodoDelegate {
    func created(_ todo: ToDo) {
        write(todo, to: realm)
        self.tableView.reloadData()
    }
}
