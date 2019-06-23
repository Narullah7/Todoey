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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dataFilePath);
        
        loadItems();

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
        
        self.saveItems();
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        let alert = UIAlertController.init(title: "Add new Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction.init(title: "Add item", style: .default) { (action) in
            
            let newItem = Item();
            newItem.title = textField.text!
            
            self.itemArray.append(newItem);
            
            self.saveItems();
            
            self.tableView.reloadData();
        }
        
        alert.addTextField { (message) in
            message.placeholder = "create new item";
            textField = message;
        }
        
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder();
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!);
        } catch{
            print("Error encoding plist file \(error)")
        }
        
        self.tableView.reloadData();
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error encoding itemArray, \(error)")
            }
        }
    }
}

