//
//  ViewController.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import UIKit
import RealmSwift

class ToDo: Object{
    @objc dynamic var isActive: Bool
    @objc dynamic var task: String
    
    required init(task: String, isActive: Bool) {
        self.task = task
        self.isActive = isActive
    }
    
    required init() {
        
        self.task = ""
        self.isActive = true
    }
}

class ViewController: UIViewController {

    let realm = try! Realm()
    
    var todos = [ToDo]()

    func testTodos(){
        try! realm.write{
            realm.deleteAll()
        }
        
        todos.append(ToDo(task: "First Test", isActive: true))
        todos.append(ToDo(task: "Second Test", isActive: false))
        todos.append(ToDo(task: "Third Test", isActive: false))
        
        try! realm.write {
            for todo in self.todos{
                realm.add(todo)
            }
        }
    }
    
    func readFromRealm() {
        for ob in realm.objects(ToDo.self) {
            todos.append(ob)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        testTodos()
        readFromRealm()
        
        
    }
    
    func countTodos(forActive isActive: Bool) -> Int{
        var count = 0
        for todo in todos where todo.isActive == isActive {
            count += 1
        }
        return count
    }


}

extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todos[section].isActive ? "Активные" : "Завершенные"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if section == 0 {
            count = countTodos(forActive: true)
        } else {
            count = countTodos(forActive: false)
        }
        
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDo") as! ToDoTableViewCell
        
        cell.nameLabel.text = todos[indexPath.section + indexPath.row].task
    
        return cell
    }


}
