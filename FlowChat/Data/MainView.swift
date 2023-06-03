//
//  MainView.swift
//  FlowChat
//
//  Created by aplle on 6/3/23.
//

import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject var userDataStore:UserDataStore
    @State private var screen = UIScreen.main.bounds
    var currentUserData:User{
        guard let uid = Auth.auth().currentUser?.uid else{return User(userName: "non", profileImage: "", chats: [Chat]())}
        
        if let user = userDataStore.users.first(where: {$0.id == uid}){
            return user
        }else{
            return User(userName: "non", profileImage: "", chats: [Chat]())
        }
    }
    var body: some View {
        ZStack{
            Color.pink.colorMultiply(.blue).ignoresSafeArea()
          
            
        }
        .overlay(alignment: .bottom, content: {content})
        .ignoresSafeArea()
        .safeAreaInset(edge: .top){
            header
        }
    }
    var content:some View{
        ScrollView(.vertical){
            
        }
        .background(.white)
        .frame(width: screen.width,height: screen.height * 0.65)
        .roundedCorner(30, corners: [.topLeft,.topRight])
        .ignoresSafeArea()
    }
    var ListOfAllUsers:some View{
        ScrollView(.horizontal,showsIndicators: false){
            
        }
    }
    var header:some View{
        VStack(spacing: 5){
            HStack{
                Text("Hi,\(currentUserData.userName)")
                    .foregroundColor(.gray)
                    .font(.callout)
                Spacer()
                Button{
                    
                }label: {
                    Image(systemName: "filemenu.and.cursorarrow")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .padding(.horizontal,20)
            HStack{
                Text("You Received")
                    .fontWeight(.light)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal,20)
            HStack{
                Text("48 Messages")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal,20)
            
            HStack{
                Text("Contacts")
                    .fontWeight(.light)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal,18)
            .padding(.top,14)
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserDataStore())
    }
}
