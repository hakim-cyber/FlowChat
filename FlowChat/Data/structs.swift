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


struct User:Codable{
    @DocumentID var id:String?
    var userName:String
    var profileImage:String
    var chats:[Chat]
}


struct Chat:Codable{
    var id = UUID()
    var participants:[User]
    var messages = [Message]()
}


struct Message:Codable{
    var id = UUID()
    var sender:User
    var content:String
    var date:String
}
