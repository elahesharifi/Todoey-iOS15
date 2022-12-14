//
//  CategoryViewController.swift
//  Todoey-iOS15
//
//  Created by Elahe  Sharifi on 02/08/2022.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController{

let realm = try! Realm()

var categories : Results<Category>!

override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
    tableView.rowHeight = 80.0
}
//MARK: - Add New Categories

@IBAction func addButtonPressed(_ sender: Any) {
    
    var textfield = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
        let newCategory = Category()
        newCategory.name = textfield.text!
        
        self.save(category: newCategory)
    }
    
    alert.addAction(action)
    alert.addTextField { (field) in
        textfield = field
        textfield.placeholder = "Add a new category"
    }
    present(alert, animated: true, completion: nil)
}
//MARK: - TableView Datasource Methods

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
}

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SwipeCollectionViewCell
//        cell.delegate = self
//        return cell
//    }
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
    cell.delegate = self
    return cell
}
//MARK: - TableView Delegate Methods

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categories[indexPath.row]
    }
}
//MARK: - Data Manipulation Methods

func save(category:Category){
    do {
        try realm.write{
            realm.add(category)
        }
    } catch {
        print("Error saving category \(error)")
    }
    tableView.reloadData()
}
func loadCategories(){
    
    categories = realm.objects(Category.self)
    
    tableView.reloadData()
}
}
//MARK: - Swipe Cell Delegate Methods

extension CategoryViewController: SwipeTableViewCellDelegate {

func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        
        if let categoryForDelection = self.categories?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDelection)
                }
                } catch {
                    print("Error deleting category, \(error)")
                }
            tableView.reloadData()
            }
    }
    // customize the action appearance
    deleteAction.image = UIImage(named: "delete-icon")
    
    return [deleteAction]
}
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
