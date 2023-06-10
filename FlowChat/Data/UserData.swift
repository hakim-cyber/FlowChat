//
//  UserData.swift
//  FlowChat
//
//  Created by aplle on 6/2/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class UserDataStore: ObservableObject {
    let db = Firestore.firestore()
    @Published var users = [User]()
    @Published var chatsForUser = [Chat]()
 
    
   var chatListeners = [ListenerRegistration]()
    func updateOrAddUser(user: User) {
        if let id = user.id {
            let docRef = db.collection("users").document(id)
            DispatchQueue.global().async {
                do {
                    try docRef.setData(from: user)
                } catch {
                    print(error)
                }
            }
        } else {
            addUser(user: user)
        }
    }
    
    func addUser(user: User) {
        let collectionRef = db.collection("users")
        DispatchQueue.global().async {
            do {
                let newDocReference = try collectionRef.addDocument(from: user)
                print("User Stored with new document reference = \(newDocReference)")
            } catch {
                print(error)
            }
        }
    }
    func addChat(participantIds:[String]){
        let chatsRef = db.collection("chats")
        let usersRef = db.collection("users")
        let uid = UUID().uuidString
        let chat = Chat(id: uid, participantsID: participantIds)
        DispatchQueue.global().sync {
           
                do{
                    
                    let docRef = chatsRef.document(uid)
                    try docRef.setData(from: chat)
                }catch{
                    print("Error adding chat \(error)")
                }
            
            for participantId in participantIds {
                do{
                   
                    let docRef = db.collection("users").document(participantId)
                    docRef.updateData(["chatsIds": FieldValue.arrayUnion([uid as String])]) { (error) in
                                                      if let error = error {
                                                          print("Error adding message: \(error)")
                                                         
                                                      } else {
                                                          
                                                      }
                                                  }
                }catch{
                    
                }
            }
        }
        
    }
    func addMessage(message:Message, to chat:Chat){
        let chatsref = db.collection("chats")
        let messagesRef = db.collection("messages")
      
        DispatchQueue.global().sync {
            
            do{
                if let id = message.id{
                    let docRef = messagesRef.document(id)
                    try docRef.setData(from: message)
                }else{
                    try messagesRef.addDocument(from: message)
                }
            }catch{
                print("Error adding chat \(error)")
            }
            let docRef = chatsref.document(chat.id!)
            
            docRef.updateData(["messagesID": FieldValue.arrayUnion([message.id ?? "" as String])]) { (error) in
                                              if let error = error {
                                                  print("Error adding message: \(error)")
                                                 
                                              } else {
                                                  
                                              }
                                          }
          
        }
    }
    
    
    func fetchUsers() {
        DispatchQueue.global().async {
           let listener = self.db.collection("users").addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                var newUsers = [User]()
                var newChats = [Chat]()
                for doc in documents {
                    do {
                        let newuser = try doc.data(as: User.self)
                        newUsers.append(newuser)
                    } catch {
                        print(error)
                    }
                }
               do{
                    let id = Auth.auth().currentUser?.uid
                    
                   if let user = newUsers.first(where:{$0.id == id}){
                       
                       self?.fetchChatsForUser(user: user){chats in
                           self?.chatsForUser = chats
                           print("fetched chats")
                       }
                   }
                
                
               }catch{
                   print(error)
               }
                
                DispatchQueue.main.async {
                    withAnimation(.easeInOut){
                        
                        self?.users = newUsers
                    }
                    print(self?.users.count ?? 0)
                }
            }
            self.chatListeners.append(listener)
        }
    }
    
     func fetchChatsForUser(user: User, completion: @escaping ([Chat]) -> Void) {
         let chatIDs = user.chatsIds
         var fetchedChats = [Chat]()

         let dispatchGroup = DispatchGroup()
         let dispatchQueue = DispatchQueue(label: "com.example.fetchchats", attributes: .concurrent)

         // Iterate over each chat ID
         for chatID in chatIDs {
             dispatchGroup.enter()
             dispatchQueue.async {
                 // Set up a listener for the chat document
                 let chatRef = self.db.collection("chats").document(chatID)
                 let listener = chatRef.addSnapshotListener { (documentSnapshot, error) in
                     guard let document = documentSnapshot else {
                         print("Error fetching chat: \(error)")
                         dispatchGroup.leave()
                         return
                     }

                     if document.exists {
                         do {
                             // Parse the chat data and update the fetchedChats array
                             if let chat = try? document.data(as: Chat.self) {
                                 if let index = fetchedChats.firstIndex(where: { $0.id == chat.id }) {
                                     fetchedChats[index] = chat
                                 } else {
                                     fetchedChats.append(chat)
                                 }
                             }
                         } catch {
                             print("Error parsing chat: \(error)")
                         }
                     }

                     dispatchGroup.leave()
                 }

                 // Store the listener for later removal if needed
                 // This assumes you have a property to hold the listeners (e.g., an array)
                 self.chatListeners.append(listener)
             }
         }

         // Notify the completion closure when all chat fetch operations have completed
         dispatchGroup.notify(queue: DispatchQueue.main) {
             completion(fetchedChats)
         }
     }
    
    
    func fetchMessagesForChat(chat: Chat, completion: @escaping ([Message]) -> Void) {
        let messageIds = chat.messagesID
        var fetchedMessages = [Message]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "com.example.fetchMessages", attributes: .concurrent)

        // Iterate over each chat ID
        for messageId in messageIds {
            dispatchGroup.enter()
            dispatchQueue.async {
                // Set up a listener for the chat document
                let messageRef = self.db.collection("messages").document(messageId)
                let listener = messageRef.addSnapshotListener { (documentSnapshot, error) in
                    guard let document = documentSnapshot else {
                        print("Error fetching message: \(error)")
                        dispatchGroup.leave()
                        return
                    }

                    if document.exists {
                        do {
                            // Parse the chat data and update the fetchedChats array
                            if let message = try? document.data(as: Message.self) {
                                if let index = fetchedMessages.firstIndex(where: { $0.id == message.id }) {
                                    fetchedMessages[index] = message
                                } else {
                                    fetchedMessages.append(message)
                                }
                            }
                        } catch {
                            print("Error parsing message: \(error)")
                        }
                    }

                    dispatchGroup.leave()
                }

                // Store the listener for later removal if needed
                // This assumes you have a property to hold the listeners (e.g., an array)
                self.chatListeners.append(listener)
            }
        }

        // Notify the completion closure when all chat fetch operations have completed
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(fetchedMessages)
        }
    }
     
    
  
}
