//
//  UserData.swift
//  FlowChat
//
//  Created by aplle on 6/2/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class UserDataStore:ObservableObject{
    let db = Firestore.firestore()
    @Published var users = [User]()
    
   

    
    
    func updateorAddUser(user:User){
        // Use for updating user ,adding with id you want , if no id it uses adding new user
        if let id = user.id{
            let docref = db.collection("users").document(id)
            
            do{
                try docref.setData(from: user)
                
            }catch{
                print(error)
            }
        }else{
            addUser(user: user)
        }
    }
    
    func addUser(user:User){
        let collectionRef = db.collection("users")
        
        do{
            let newDocReference = try collectionRef.addDocument(from: user)
            print("User Stored with new document reference = \(newDocReference)")
        }catch{
            print(error)
        }
    }
    
    
    func fetchUsers() {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard  error == nil else{
                
                print(error as Any)
                return
            }
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
            
           var newUsers = [User]()
                for doc in documents {
                    do{
                       var newuser =  try doc.data(as: User.self)
                        newUsers.append(newuser)
                    }catch{
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    self.users = newUsers
                    print(self.users.count)
                }
              
            }
        }
  
 
    
}
