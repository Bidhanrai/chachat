//
//  Database.swift
//  ChaChat
//
//  Created by Bidhan Rai on 24/01/2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

class DatabaseManager {
    let db = Firestore.firestore().collection("messages")
    let storageRef = Storage.storage().reference()
    
    func fetchCurrentUser()-> String{
        return FirebaseAuth.Auth.auth().currentUser!.uid
    }
    
    func loadChat() {
        
    }
    
    //uplod image that will be sent to a converstion message
    func uploadMessagePhoto(data: Data, imagePath: URL, completionHandler: @escaping (_ url: String?) -> Void){
    
      
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("messagePhoto/\(imagePath.lastPathComponent)")
        
        let uploadTask = imageRef.putFile(from: imagePath, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                print("Error while uploading photo.")
                return
            }
            
            let size = metadata.size
            print(size)
            
            imageRef.downloadURL(completion: { (url, error) in
                guard let downloadUrl = url else {
                    print("Error while getting download url.")
                    return
                }
            
                completionHandler(downloadUrl.absoluteString)
            })
        }
        
        // Create a task listener handle
        let observer = uploadTask.observe(.progress) { snapshot in
          // A progress event occurred
            print(snapshot.progress!)
        }
        
        
    }

}
