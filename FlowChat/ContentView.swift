//
//  ContentView.swift
//  FlowChat
//
//  Created by aplle on 6/1/23.
//

import SwiftUI
import Firebase
struct ContentView: View {
    @State private var screen = UIScreen.main.bounds
    @EnvironmentObject var userDataStore:UserDataStore
    var body: some View {
        ZStack {
         
        MainView()
        .transition(.move(edge: .bottom))
             
               
        }
       
        .onAppear{
          
         fetchChatsForUser()
     
        }
        .ignoresSafeArea()
        
        
    }
    var bacground:some View{

        return ZStack{
            Color.blue.colorMultiply(.pink).ignoresSafeArea()
            VStack{
                Spacer()
                Image("background1")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
            }
            .padding(.top)
            .ignoresSafeArea()
        }
    }
    func fetchChatsForUser(){
        DispatchQueue.main.async {
            
            
            guard let id = Auth.auth().currentUser?.uid else{
                print(("no id"))
                return}
            userDataStore.fetchUsers()
            
            if let user = userDataStore.users.first(where: {$0.id == id}){
                userDataStore.fetchChatsForUser(user: user){chats in
                    userDataStore.chatsForUser = chats
                    print("start chat fetching")
                }
            }else{
                print("no user")
            }
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
