//
//  ViewController.swift
//  LivSecurityShoppingList
//
//  Created by Vanoshan  Ramdhani on 2022/03/01.
//

import CloudKit
import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var items = [String]()
    let cellIdentifier = "cellIdentifier"
    let control = UIRefreshControl()
    
    //creating the tableview
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping List"
        view.addSubview(tableView)
        tableView.dataSource = self
        //adding the pullToRefresh function to the UIRefreshControl()
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = control
        //adding the didTapAdd function to the button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        fetchItems()
    }
    
    //MARK: - Database Queries
    //fetches all the items in the Database
    @objc func fetchItems(){
        let query = CKQuery(recordType: RecordTypes.ShoppingList, predicate: NSPredicate(value: true))
        Database.databaseShoppingList.perform(query, inZoneWith: nil) { [weak self]records, error in
            guard let records = records, error == nil else{
                return
            }
            DispatchQueue.main.sync {
                self?.items = records.compactMap({$0.value(forKey: Records.shoppingItem) as? String})
                self?.tableView.reloadData()
            }
        }
    }
    //Refreshes the table and gets the items from the database
    @objc func pullToRefresh(){
        tableView.refreshControl?.beginRefreshing()
        let query = CKQuery(recordType: RecordTypes.ShoppingList, predicate: NSPredicate(value: true))
        Database.databaseShoppingList.perform(query, inZoneWith: nil) { [weak self]records, error in
            
            guard let records = records, error == nil else{
                return
            }
            DispatchQueue.main.sync {
                self?.items = records.compactMap({$0.value(forKey: Records.shoppingItem) as? String})
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    //saves a new item to the Database
    @objc func saveItem(name: String){
        let record = CKRecord(recordType: RecordTypes.ShoppingList)
        record.setValue(name, forKey: Records.shoppingItem)
        Database.databaseShoppingList.save(record){ [weak self]record, error in
            if record != nil, error == nil{
                DispatchQueue.main.asyncAfter(deadline: .now()+2){
                    self?.fetchItems()
                }
            }
        }
    }
    
    //MARK: - Tapped Add Button
    //Tapp button functionality to save a new item to the Database
    @objc func didTapAdd(){
        let alert = UIAlertController(title: "Add Shopping List Item", message: nil, preferredStyle: .alert)
        alert.addTextField{ field in
            field.placeholder = "Enter Item Name..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            if let field = alert.textFields?.first, let text = field.text, !text.isEmpty{
                self?.saveItem(name: text)
            }
        }))
        present(alert, animated: true)
    }
    //MARK: - TableView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    //sets the text of each row of the items in the Database
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    //returns the number of rows to show
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //Swipe to delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let record = CKRecord(recordType: RecordTypes.ShoppingList)
        if editingStyle == UITableViewCell.EditingStyle.delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            Database.databaseShoppingList.delete(withRecordID: record.recordID) { (deletedRecordID, error) in
                if error == nil {
                    print("Record Deleted")

                } else {
                    print("Record Not Deleted")
                }

            }
        }
    }
}
    


