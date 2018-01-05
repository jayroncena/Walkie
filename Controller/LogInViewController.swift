//
//  LogInViewController.swift
//  Walkie
//
//  Created by wonjongpill on 2017. 12. 31..
//  Copyright © 2017년 Jayron Cena. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    private let owner_segue = "OwnerViewController"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logIn(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                if message != nil{
                    self.alertTheUser(title: "Problem with Authentication", message: message!)
                }
                else{
                    WalkieHandler.Instance.owner = self.emailTextField.text!
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    self.performSegue(withIdentifier: self.owner_segue, sender: nil)
                }
            })
           
        }else{
            alertTheUser(title: "Email and password Are required", message: "Please enter email and password in the text fields")
        }
        
       
        
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                if message != nil{
                    self.alertTheUser(title: "Problem with creating a new user", message: message!)
                }
                else{
                    self.performSegue(withIdentifier: self.owner_segue, sender: nil)
                }
            })
            
        }else{
            alertTheUser(title: "Email and password Are required", message: "Please enter email and password in the text fields")
        }
    }
    
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
    }
    
    
    
    
    
    

}
