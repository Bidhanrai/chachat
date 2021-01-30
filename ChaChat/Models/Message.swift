//
//  Message.swift
//  ChaChat
//
//  Created by Bidhan Rai on 26/01/2021.
//

import Foundation
import MessageKit
import FirebaseFirestore

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize    
}

class MessageReceived: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(sender: SenderType, messageId: String, timestamp: Timestamp, kind: MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        self.kind = kind
    }
}

struct MessageSend {
    var senderId: String
    var message: String
    var date: Date
    var senderName: String
    var imageUrl: String
}
