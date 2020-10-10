//
//  ViewController.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var categories = [Category]()
    var presenter: PresenterInput! = CategoryPresenter()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.output = self
        presenter.loadCategories()
    }

}

extension ViewController: PresenterOutput {
    func updateTableView(with categories: [Category]) {
        self.categories = categories
        self.tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryTableViewCell
        
        let cat = categories[indexPath.row]
        
        cell.nameLabel.text = cat.name
        
        return cell
    }
    
    
}
