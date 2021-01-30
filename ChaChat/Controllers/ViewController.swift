//
//  ViewController.swift
//  ChaChat
//
//  Created by Bidhan Rai on 22/01/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import MessageUI
import Messages


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
//    var messages: [Message]! = [Message]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        self.textField.delegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Check if user is logged in
        if FirebaseAuth.Auth.auth().currentUser == nil {
            goToLoginView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
//
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
//        let messageSnap: Message! = self.messages[indexPath.row]
//        let message = messageSnap.text
//
//        cell.textLabel?.textAlignment = .right
        cell.textLabel?.text = "Joe Biden"
    
        
//
//        let subText = messageSnap.dateTime
//        cell.detailTextLabel?.text = Utilities().formatDate(date: subText)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: ACTION FUNCTIONS
    @IBAction func logoutUser() {
        //logout the user
        let firebaseAuth = FirebaseAuth.Auth.auth()
        do {
            try firebaseAuth.signOut()
            goToLoginView()
        } catch {
            print("error signing out!")
        }
    }
    
    func goToLoginView() {
        let vc = self.storyboard?.instantiateViewController(identifier: "firebaseLoginViewController")
        vc?.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    

    //MARK: HELPER FUNCTIONS
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        sendMessage()
//        self.view.endEditing(true)
//        return true
//    }
    
//    func sendMessage() {
//        if !textField.text!.isEmpty {
//            let data = ["text": textField.text!, "datetime": Timestamp(date: Date()), "id": FirebaseAuth.Auth.auth().currentUser?.uid as Any] as [String : Any]
//            Database().db.addDocument(data: data, completion: nil)
//            textField.text?.removeAll()
//        }
//    }
    
    
//    @objc func keyboardWillShow(_ sender: NSNotification) {
//        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
//
////        let keyboardSize: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect)
//
//        let offset: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect)
//
//        if self.view.frame.origin.y == 0 {
//            UIView.animate(withDuration: 0.15, animations: {
//                self.view.frame.origin.y -= offset.height
//            })
//        }
//
////        if keyboardSize.height == offset.height {
////            if self.view.frame.origin.y == 0 {
////                UIView.animate(withDuration: 0.15, animations: {
////                    self.view.frame.origin.y -= keyboardSize.height
////                })
////            }
////        } else {
////            UIView.animate(withDuration: 0.15, animations: {
////                self.view.frame.origin.y += keyboardSize.height - offset.height
////            })
////        }
//    }
//
//    @objc func keyboardWillHide(_ sender: NSNotification) {
//        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
//
//        let keyboardSize: CGRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//        self.view.frame.origin.y += keyboardSize.height
//    }

}

