//
//  ChatViewController.swift
//  ChaChat
//
//  Created by Bidhan Rai on 26/01/2021.
//

import UIKit
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView
import SDWebImage


class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let currentUser = Sender(senderId: DatabaseManager().fetchCurrentUser(), displayName: "test")
    var messages = [MessageType]()
    
    var imagePath: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //database configure
        DatabaseManager().db.order(by: keyNames.date).addSnapshotListener { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }

            self.messages = documents.map{ queryDocumentSnapShot -> MessageReceived in
                let text: String = (queryDocumentSnapShot[keyNames.message] as! Dictionary<String, Any>)[keyNames.text] as! String
                let imageUrl: String = (queryDocumentSnapShot[keyNames.message] as! Dictionary<String, Any>)[keyNames.imageUrl] as! String
                let timestamp: Timestamp = (queryDocumentSnapShot[keyNames.date] as! Timestamp)
                let userId: String = (queryDocumentSnapShot[keyNames.user] as! Dictionary<String, Any>)[keyNames.userId] as! String
                let userName: String = (queryDocumentSnapShot[keyNames.user] as! Dictionary<String, Any>)[keyNames.userName] as! String
                                
                if !imageUrl.isEmpty {
                    return MessageReceived(sender: Sender(senderId: userId, displayName: userName), messageId: queryDocumentSnapShot.documentID, timestamp: timestamp, kind: .photo(Media(url: URL(string: imageUrl), image: nil, placeholderImage: UIImage(systemName: "paperclip")!, size: CGSize(width: 250, height: 100))))
                } else {
                    return MessageReceived(sender: Sender(senderId: userId, displayName: userName), messageId: queryDocumentSnapShot.documentID, timestamp: timestamp, kind: .text(text))
                }
            }
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }
    
        }
       
        messageInputBar.delegate = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        setupInputBarButton()
    }
    
    func setupInputBarButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside({_  in
            self.presentInputActionSheet()
        })
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)

    }
    
    private func presentInputActionSheet() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            else{
                return
            }
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        imagePath = fileUrl
        
        //pasting image to textView
        let pasteboard = UIPasteboard.general
        pasteboard.image = image
        messageInputBar.inputTextView.paste(pasteboard)
    }
    
    
    
    //triggers when send button is clicked
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if !inputBar.inputTextView.text.isEmpty {
            let image = inputBar.inputTextView.images
            
            //send latest selected image
            if image.count != 0 {
                
//                DispatchQueue.global(qos: .background).async {
//            
//                }
                DatabaseManager().uploadMessagePhoto(data: image[image.count-1].pngData()!, imagePath: self.imagePath!) { url in
                  
                    let data = MessageSend(senderId: DatabaseManager().fetchCurrentUser(), message: text, date: Date(), senderName: "test", imageUrl: url!)
                                               
                    self.sendMessage(data: data)
                }
                
                inputBar.inputTextView.text = ""
                   
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
                
            } else {
                let data = MessageSend(senderId: DatabaseManager().fetchCurrentUser(), message: text, date: Date(), senderName: "test", imageUrl: "")
                                           
                    self.sendMessage(data: data)
                   
                    inputBar.inputTextView.text = ""
                   
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
            }
        
        }
    }
    
    func sendMessage(data: MessageSend) {
        let data: [String: Any] = [keyNames.message: [keyNames.text: data.message,
                                                      keyNames.imageUrl: data.imageUrl],
                                   keyNames.date: Timestamp(date: data.date),
                                   keyNames.user: [keyNames.userId: data.senderId, keyNames.userName: data.senderName]]
        

     
        DatabaseManager().db.addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            print("Message Sent")
        })
    }
}


extension ChatViewController: MessageCellDelegate {
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        guard let message = message as? MessageReceived else {
            return
        }
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            return
        }
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        let message = messages[indexPath.section]
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewController(with: imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            return
        }
    }
}
