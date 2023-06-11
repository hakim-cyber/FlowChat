//
//  structs.swift
//  FlowChat
//
//  Created by aplle on 6/2/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

/*
 struct User: Codable {
     @DocumentID var id: String?
     var userName: String
     var profileImage: String
     var chatIDs: [String] // Store chat IDs instead of the entire Chat objects
 }

 struct Chat: Codable {
     var id = UUID()
     var participants: [User]
     var messageIDs: [String] // Store message IDs instead of the entire Message objects
 }

 struct Message: Codable {
     var id = UUID()
     var senderID: String // Store the sender's ID instead of the entire User object
     var content: String
     var date: String
 }
 */
struct User:Codable{
    @DocumentID var id:String?
    var userName:String
    var profileImage:String
    var chatsIds:[String]
}


struct Chat:Codable{
    @DocumentID var id:String?
    var title:String?
    var participantsID:[String]
    var messagesID = [String]()
}


struct Message:Codable{
    @DocumentID var id:String?
    var senderID:String
    var content:String
    var date:String
}
