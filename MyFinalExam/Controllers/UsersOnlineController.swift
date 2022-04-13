//
//  UsersOnlineController.swift
//  MyFinalExam
//
//  Created by Tarooti on 10/06/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class UsersOnlineController: UITableViewController {
    // Define DB
    let root = Database.database().reference()
    // an array of type struct
    var items : [Users] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set row height to 50
        tableView.rowHeight = 50
        // fetch data from firebase
        fetchData()
    }

    // check if user already sign in
    func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            // go to login page
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.performSegue(withIdentifier: "goToLoginSegue", sender: self)

        }
        
    }

    func fetchData(){
        // remove all items from array
        self.items.removeAll()
       // get node from firebase realtime DB
        root.child("online").observeSingleEvent(of: .value) { snapshot in
            guard let userNode = snapshot.value as? [String:AnyObject] else{
                return
            }
            var fetchData = Users()
            for (_,value) in userNode {
                // assgin value
                fetchData.email = value["name"] as! String
                // add to array ( items )
                self.items.append(fetchData)
                // reload table view
                self.tableView.reloadData()
            }
        
            // sort array by email
            self.items.sort(by: {$0.email < $1.email})

        }
    }
    @IBAction func SignoutPressed(_ sender: Any) {
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            guard let userID = FirebaseAuth.Auth.auth().currentUser?.uid  else{
                return
            }
            // get node from firebase realtime DB to delete it
            let usersList = self.root.child("online").child(userID)
            usersList.removeValue()
            // go to login page
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.performSegue(withIdentifier: "goToLoginSegue", sender: self)

        }
        do {
            // Sginout from firebase
            try FirebaseAuth.Auth.auth().signOut()
            // go to login page
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.performSegue(withIdentifier: "goToLoginSegue", sender: self)
        }
        catch {
            print("failed to logout")
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as! UsersTableViewCell
        cell.lblEmail.text = self.items[indexPath.row].email
        
        return cell 
    }
    


}
