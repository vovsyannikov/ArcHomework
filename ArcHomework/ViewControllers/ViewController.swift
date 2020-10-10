//
//  ViewController.swift
//  ArcHomework
//
//  Created by Виталий Овсянников on 10.10.2020.
//

import UIKit

class ViewController: UIViewController {
    var categories = [Category]()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTableView() { self.tableView.reloadData() }
    }
    
    func updateTableView(completion: @escaping (() -> Void)){
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let jsonDict = json as? NSDictionary {
//                print(jsonDict)
                for (_, data) in jsonDict where data is NSDictionary {
                    if let category = Category(data: data as! NSDictionary) {
                        print("+++\(category)+++")
                        self.categories.append(category)
                    }
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
        task.resume()
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

struct Category: CustomStringConvertible {
    var description: String { "\(name)"}
    
    let imageURL: String
    let name: String
    
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
              let imageURL = data["image"] as? String else {
            return nil
        }
        
        self.name = name
        self.imageURL = imageURL
    }
}

