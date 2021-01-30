//
//  LoginRegisterViewController.swift
//  ChaChat
//
//  Created by Bidhan Rai on 22/01/2021.
//

import UIKit
import Firebase

class LoginRegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //MARK: ACTION FUNCTIONS
    @IBAction func loginButtonClicked(_ sender: Any) {
        if !checkInput() {
            return
        }
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                Utilities().showAlert(title: "Error!", message: error.localizedDescription, vc: self)
                print(error.localizedDescription)
                return
            }
            print("Signed In!")
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        if !checkInput() {
            return
        }
        
        let alert = UIAlertController(title: "register", message: "Please confirm password!", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "confirm password"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let passConfirm = alert.textFields![0] as UITextField
            if passConfirm.text == self.passwordTextField.text {
                
                //registration begins
                FirebaseAuth.Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    if let error = error {
                        Utilities().showAlert(title: "Error!", message: error.localizedDescription, vc: self)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                Utilities().showAlert(title: "Error!", message: "Passwords not the same", vc: self)
            }
        }))
        self.present(alert, animated: true, completion: nil )
    }
    
    @IBAction func forgotPasswordButtonClicked(_ sender: Any) {
        if !emailTextField.text!.isEmpty {
            FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                if let error = error {
                    Utilities().showAlert(title: "Error!", message: error.localizedDescription, vc: self)
                } else {
                    Utilities().showAlert(title: "Success!", message: "Please check your email!", vc: self)
                }
            })
        }
    }
    
    
    //MARK: HELPER FUNCTIONS
    func checkInput()-> Bool {
        if emailTextField.text!.count < 5 {
            emailTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.3)
            return false
        } else {
            emailTextField.backgroundColor = UIColor.white
        }
        
        if passwordTextField.text!.count < 5 {
            passwordTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.3)
            return false
        } else {
            passwordTextField.backgroundColor = UIColor.white
        }
        return true
    }

}
