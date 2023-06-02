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
    init(){
        FirebaseApp.configure()
    }
   
    var body: some Scene {
        WindowGroup {
        
                    StartView()
                .environmentObject(userDataStore)
                
            
           
        }
        
    }
}
