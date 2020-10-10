//
//  ViewController.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import UIKit
import RealmSwift

//MARK: Класс задачи
class ToDo: Object{
    @objc dynamic var isActive: Bool
    @objc dynamic var task: String
    var attributedTask: NSAttributedString {
        isActive
            ? fixedText(from: task)
            : strikethroughText(from: task)
    }
    
    required init(task: String, isActive: Bool) {
        self.task = task
        self.isActive = isActive
    }
    
    required init() {
        
        self.task = ""
        self.isActive = true
    }
    
    static func == (left: ToDo, right: ToDo) -> Bool {
        return left.task == right.task && left.isActive == right.isActive
    }
    
    func strikethroughText(from input: String) -> NSAttributedString {
        let strikethroughAttribute = [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue]
        let resultingString = NSAttributedString(string: input, attributes: strikethroughAttribute)
        
        return resultingString
    }
    
    func fixedText(from input: String) -> NSAttributedString {
        let result = NSAttributedString(string: input)
        
        return result
    }
}

//MARK: ViewController
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func clear(_ sender: Any) {
        clearCompleted()
    }
    
    let realm = try! Realm()
    
    var todos = [ToDo]()
    var completed = [ToDo]()
    
    // Making test todos
    func testTodos(){
        
        todos.append(ToDo(task: "First Test", isActive: true))
        completed.append(ToDo(task: "Second Test", isActive: false))
        completed.append(ToDo(task: "Third Test", isActive: false))
        
        try! realm.write {
            for todo in self.todos{
                realm.add(todo)
            }
        }
    }
    
    //MARK: Realm funcs
    func readFromRealm() {
        todos = []
        completed = []
        
        for ob in realm.objects(ToDo.self) {
            switch  ob.isActive {
            case true:
                todos.append(ob)
            case false:
                completed.append(ob)
            }
        }
    }
    
    func writeToRealm(_ todo: ToDo){
        try! realm.write {
            realm.add(todo)
        }
        switch todo.isActive {
        case true:
            todos.append(todo)
        case false:
            completed.append(todo)
        }
        
        self.tableView.reloadSections(IndexSet(0...1), with: .automatic)
    }
    
    //ToDo isActive toggle
    func toggle(_ todo: ToDo){
        try! realm.write {
            var indexToModify: Int!
            for (i, obj) in realm.objects(ToDo.self).enumerated() {
                if obj == todo {
                    indexToModify = i
                    break
                }
            }
            realm.objects(ToDo.self)[indexToModify].isActive.toggle()
        }
        
        readFromRealm()
        self.tableView.reloadSections(IndexSet(0...1), with: .automatic)
    }
    
    func clearCompleted(){
        var indexesToDelete: [IndexPath] = []
        
        try! realm.write {
            for (i, todo) in completed.enumerated(){
                indexesToDelete.append(IndexPath(row: i, section: 1))
                realm.delete(todo)
            }
            completed = []
        }
        
        self.tableView.deleteRows(at: indexesToDelete, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateTodoViewController, segue.identifier == "CreateToDo"{
            vc.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        testTodos()
        readFromRealm()
        
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
        print(indexPath.row, indexPath.section)
        print(todos, completed)
        let todo = indexPath.section == 0 ? todos[indexPath.row] : completed[indexPath.row]
        toggle(todo)
        
    }
}

extension ViewController: CreateTodoDelegate {
    func created(_ todo: ToDo) {
        writeToRealm(todo)
    }
    
    
}
