//
//  Utilities.swift
//  ChaChat
//
//  Created by Bidhan Rai on 22/01/2021.
//

import UIKit

class Utilities {
    
    func showAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func formatDate(date: Date)-> String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: date)
        
    }
    
  
}
