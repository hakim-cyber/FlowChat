//
//  FlowChatApp.swift
//  FlowChat
//
//  Created by aplle on 6/1/23.
//

import SwiftUI
import Firebase

@main
struct FlowChatApp: App {
    @StateObject var userDataStore = UserDataStore()
    @AppStorage("InfoAdded")  var InfoAdded = false
    @AppStorage("userLogedIn") var userLogedIn = false
    init(){
        FirebaseApp.configure()
    }
   
    var body: some Scene {
        WindowGroup {
            ZStack{
                if InfoAdded && userLogedIn{
                                 ContentView()
                             }else{
                                 StartView()
                             }
                           
         
            }
            .environmentObject(userDataStore)
                   
                
            
           
        }
        
    }
}
