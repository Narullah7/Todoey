//
//  ViewController.swift
//  Todoey
//
//  Created by Narullah Noor on 30/03/2019.
//  Copyright © 2019 Narullah Noor. All rights reserved.
//

import UIKit

class TodoeyListViewController: UITableViewController {

    var itemArray = [Item]();
    
    let userDefaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item();
        newItem.title = "Find Mike";

        itemArray.append(newItem);
        
        if let items = userDefaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath);
        
        let item = itemArray[indexPath.row];
        
        cell.textLabel?.text = item.title;
        
        cell.accessoryType = item.isDone ? .checkmark : .none;

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        tableView.reloadData();
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        let alert = UIAlertController.init(title: "Add new Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction.init(title: "Add item", style: .default) { (action) in
            
            let newItem = Item();
            newItem.title = textField.text!
            
            self.itemArray.append(newItem);
            
            self.userDefaults.set(self.itemArray, forKey: "TodoListArray");
            
            self.tableView.reloadData();
        }
        
        alert.addTextField { (message) in
            message.placeholder = "create new item";
            textField = message;
        }
        
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
}

