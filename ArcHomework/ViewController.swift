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
}



class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    var todos = [ToDo]()
    var completed = [ToDo]()
    
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
    
    func toggle(_ todo: ToDo){
        try! realm.write {
            var indexToModify = 10
            for (i, obj) in realm.objects(ToDo.self).enumerated() {
                if obj == todo {
                    print("Found \(obj) == \(todo)")
                    indexToModify = i
                    break
                }
            }
            realm.objects(ToDo.self)[indexToModify].isActive.toggle()
        }
        
        readFromRealm()
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        testTodos()
        readFromRealm()
        
        
    }
    
}

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
        toggle(todo)
        
    }
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
