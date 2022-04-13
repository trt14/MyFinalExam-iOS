//
//  DatabaseManger.swift
//  MyFinalExam
//
//  Created by Tarooti on 09/06/1443 AH.
//

import Foundation
import FirebaseDatabase


final class DatabaseManger {

    static let shared = DatabaseManger()
    private let database = Database.database().reference()
    public func AddNewItem(result:GroceryItem) {
        
     
        database.child("foo").setValue(["something":true])
    }

}
