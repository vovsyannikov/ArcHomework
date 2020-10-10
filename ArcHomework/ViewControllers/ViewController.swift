//
//  ViewController.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    let model = BSWModel()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTableView()
    }
    
    func updateTableView(){
        model.loadCategories() { self.tableView.reloadData() }
    }

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryTableViewCell
        
        let cat = model.categories[indexPath.row]
        
        cell.nameLabel.text = cat.name
        
        return cell
    }
    
    
}
