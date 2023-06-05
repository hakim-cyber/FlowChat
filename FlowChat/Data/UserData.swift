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
    @Published var messagesForUser = [Message]()
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
    
    func fetchUsers() {
        DispatchQueue.global().async {
            self.db.collection("users").addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                var newUsers = [User]()
                for doc in documents {
                    do {
                        let newuser = try doc.data(as: User.self)
                        newUsers.append(newuser)
                    } catch {
                        print(error)
                    }
                }
                
                DispatchQueue.main.async {
                    withAnimation(.easeInOut){
                        
                        self?.users = newUsers
                    }
                    print(self?.users.count ?? 0)
                }
            }
        }
    }
    
    
}
