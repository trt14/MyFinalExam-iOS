//
//  GroceryTableViewController.swift
//  MyFinalExam
//
//  Created by Tarooti on 09/06/1443 AH.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class GroceryTableViewController: UITableViewController {
    // an array of type struct
    var items : [GroceryItem] = []
    var txt : String = ""
    // Define DB
    let root = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set row height to 50
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        // fetch Data when load a page
        fetchData()
        // validate when load a page
        validateAuth()

       
    }

    // check if user already sign in
    func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            // go to login page
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.performSegue(withIdentifier: "goToLoginSegue", sender: self)

        }
        
    }
    @IBAction func AddPressed(_ sender: Any) {
        // Create an alert to add an item
        let alert = UIAlertController(title: "Add", message: "Grocery Item", preferredStyle: .alert)
        // create a text field
        alert.addTextField { (textField) in
            textField.placeholder = "Enter an item"
        }
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        // add Action to alert Name it as OK
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields![0] else{
                return
            }
            // create UUID to save it in DB then Set node to set a value
            let IDItem = UUID().uuidString
            let groceryListItemsRef = self.root.child("grocery-items").child(IDItem)
            let Data : [String : Any] = ["IDItem":IDItem,
                                         "AddByUser":currentUserEmail ,
                                         "completed":false ,
                                         "name":textField.text!]
            groceryListItemsRef.setValue(Data)
            self.fetchData()

        }))
        // add Action to alert Name it as Cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // present an alert
        self.present(alert, animated: true, completion: nil)

    }
    
    
    @IBAction func UsersOnlinePressed(_ sender: Any) {
        // Go to Users Online Page
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.performSegue(withIdentifier: "goToUsersSegue", sender: self)

    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! GroceryItemCell
        // assgin value to cell
        cell.lblName.text = items[indexPath.row].name
        cell.lblEmail.text = items[indexPath.row].AddByUser
        cell.isChecked.isHidden = !items[indexPath.row].complete
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create alert
        let alert = UIAlertController(title: "Update", message: "Grocery Item", preferredStyle: .alert)
        // Define a text field
        alert.addTextField { (textField) in
            textField.placeholder = self.items[indexPath.row].name
        }
        
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        // check if a user can edit or delete for other users
        if(currentUserEmail != self.items[indexPath.row].AddByUser){
            print("You can't edit")
            errorAlert()

        }else{
            // add Action to alert Name it as Update
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak alert] (_) in
                guard let textField = alert?.textFields![0] else{
                    return
                }
                // Get node from firebase real time DB then update value
                let groceryListItemsRef = self.root.child("grocery-items")
                let itemRef = groceryListItemsRef.child(self.items[indexPath.row].itemID)
                itemRef.updateChildValues(["name" : textField.text!])
                self.fetchData()
            }))
            
            if self.items[indexPath.row].complete == false {
                // add Action to alert Name it as Completed
                alert.addAction(UIAlertAction(title: "Completed", style: .default, handler: { (_) in
                    // Get node from firebase real time DB then update value , if complete it
                    let groceryListItemsRef = self.root.child("grocery-items")
                    let itemRef = groceryListItemsRef.child(self.items[indexPath.row].itemID)
                    itemRef.updateChildValues(["completed" : true])
                    self.fetchData()

                }))
            }else{
                // add Action to alert Name it as NotCompleted
                alert.addAction(UIAlertAction(title: "NotCompleted", style: .default, handler: {  (_) in
                    // Get node from firebase real time DB then update value , if not complete it
                    let groceryListItemsRef = self.root.child("grocery-items")
                    let itemRef = groceryListItemsRef.child(self.items[indexPath.row].itemID)
                    itemRef.updateChildValues(["completed" : false])
                    self.fetchData()

                }))
            }
    

        }

    
        // add Action to alert Name it as Cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // present an alert
        self.present(alert, animated: true, completion: nil)

    }
    
    // alert error
    func errorAlert(){
        let alert = UIAlertController(title: "OOOPS!", message: "Sorry!You Can't edit or delete for other account", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    // fetch data from realtime DB
    func fetchData(){
        // Delete all items array
        self.items.removeAll()
        // get node from firebase realtime DB
        root.child("grocery-items").observeSingleEvent(of: .value) { snapshot in
            guard let userNode = snapshot.value as? [String:AnyObject] else{
                return
            }
            var fetchData = GroceryItem()
            for (_,value) in userNode {
                // assgin value
                fetchData.AddByUser = (value["AddByUser"] as! String)
                fetchData.name = (value["name"] as! String)
                fetchData.complete = (value["completed"] as! Bool)
                fetchData.itemID = (value["IDItem"] as! String)
                // add to array ( items )
                self.items.append(fetchData)
                // reload table view
                self.tableView.reloadData()
            }
        
            // sort array by names 
            self.items.sort(by: {$0.name < $1.name})

        }
    }
    // Delete an item from firebase
     func removeItem(parentA: String) {

          root.child("grocery-items").child(parentA).removeValue()
        
         print("Delete it Sucessful")
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                return
            }
            // check if the user can delete items for other users
            if(currentUserEmail != self.items[indexPath.row].AddByUser){
                print("You can't Delete")
                // show an alert
                errorAlert()

            }else{
                // Delete it successfully
                let itemID = self.items[indexPath.row].itemID
                removeItem(parentA: itemID)
                // Delete it from array
                items.remove(at: indexPath.row)
                // reload table view
                tableView.reloadData()

            }
        }
    }
    

}
