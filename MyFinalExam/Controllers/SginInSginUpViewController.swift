//
//  SginInSginUpViewController.swift
//  MyFinalExam
//
//  Created by Tarooti on 09/06/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SginInSginUpViewController: UIViewController {

    // define Database
    let root = Database.database().reference()
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // check if a user login or register
        validateAuth()
    
    }
    
    // check if a user login or register
    func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser != nil {
            // Go to main Page after login
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.performSegue(withIdentifier: "mainSegue", sender: self)

        }
        
    }
    // Login Button
    @IBAction func LoginPressed(_ sender: Any) {
        guard let Email = txtEmail.text,
              let Password = txtPassword.text else{
                  return
              }
        // check if its null or not
        if Email.isEmpty && Password.isEmpty {
            lblError.isHidden = false
            lblError.text = "You should fill the blanks!"
        }else{
            login(email: Email, pass: Password)

        }
    }
    // Register Button
    @IBAction func SginupPressed(_ sender: Any) {
        
        guard let Email = txtEmail.text,
              let Password = txtPassword.text else{
                  return
              }
        // check if its null or not
        if Email.isEmpty && Password.isEmpty {
            lblError.isHidden = false
            lblError.text = "You should fill the blanks!"
        }else{
            CreateAccount(email:Email,pass:Password)

        }
    }
    

    func CreateAccount(email:String,pass:String){
        // Save an email
        UserDefaults.standard.setValue(email, forKey: "email")
        // Create User in Firebase
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pass, completion: {[weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Error creating user\(String(describing: error))")
              // Check error code
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    strongSelf.lblError.isHidden = false
                            switch errCode {
                            case .emailAlreadyInUse:
                            print("used email")
                                strongSelf.lblError.text = "Sorry!Your E-mail used before :("
                            case .weakPassword:
                                strongSelf.lblError.text = "Sorry!Your Password is waek :("

                            default:
                            print("Create User Error: \(error!)")
                            }
                        }
                return
            }
            // if success do

            
            let user = result.user
            // add online users to firebase realtime DB
            strongSelf.root.child("online").child(user.uid).setValue(["name":email])
            self?.lblError.isHidden = true

            // go to main Page
            strongSelf.navigationController?.setNavigationBarHidden(true, animated: false)
            strongSelf.performSegue(withIdentifier: "mainSegue", sender: self)

              
        })

    }
    
    func login(email:String,pass:String){
        UserDefaults.standard.setValue(email, forKey: "email")
        // login to Firebase
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
         
            guard let result = authResult, error == nil else {
                // Check error code
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    self?.lblError.isHidden = false
                            switch errCode {
                            case .wrongPassword:
                            print("wrongPassword")
                            self?.lblError.text = "Sorry!Your Password is wrong :("
                            case .invalidEmail:
                            self?.lblError.text = "Sorry!Your Enter invalid E-mail  :("
                            case .userNotFound:
                            self?.lblError.text = "User not Found,You need to register"

                            default:
                            print("Create User Error: \(error!)")
                            }
                        }
                return
            }
            // if success do
            self?.lblError.isHidden=true
            let user = result.user
            // add online users to firebase realtime DB
            strongSelf.root.child("online").child(user.uid).setValue(["name":email])

            self?.lblError.isHidden = true

            
            // go to main Page
            strongSelf.navigationController?.setNavigationBarHidden(true, animated: true)
            strongSelf.performSegue(withIdentifier: "mainSegue", sender: self)
        })
    
    }
}
