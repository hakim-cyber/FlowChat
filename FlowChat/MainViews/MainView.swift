//
//  MainView.swift
//  FlowChat#imageLiteral(resourceName: "ChatApp 2.webp")
//
//  Created by aplle on 6/3/23.
//

import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject var userDataStore:UserDataStore
    @State private var screen = UIScreen.main.bounds.size
    @State private var showAddView = false
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
            Image("photo7")
                .resizable()
                .ignoresSafeArea()
                
            
        }
        .padding(.top)
        .overlay(alignment: .bottom, content: {content})
        .overlay(alignment: .top){
            header
        }
        .overlay{
            if showAddView{
                AddView(){ participants in
                    if participants.count <= 1{
                      // nothing to do
                        withAnimation(.easeInOut(duration: 0.4)){
                          
                                showAddView.toggle()
                            
                        }
                    }else{
                        // add new chat with participants
                        withAnimation(.easeInOut(duration: 0.4)){
                            
                                showAddView.toggle()
                            
                        }
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
               
                
           
                
            }
        }
        .ignoresSafeArea()
       
    }
    var content:some View{
        VStack{
            Spacer()
            ScrollView(.vertical){
                
            }
            .background(.white)
            .frame(maxWidth: .infinity,maxHeight:.infinity,alignment:.bottom)
            .frame(width: screen.width,height: screen.height * 0.65)
            .roundedCorner(30, corners: [.topLeft,.topRight])
            .ignoresSafeArea()
        }
    }
    var ListOfAllUsers:some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack(alignment: .top,spacing: 5){
                Button{
                    // new chat
                    withAnimation(.easeInOut(duration: 0.4)){
                       
                            showAddView.toggle()
                        
                    }
                }label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .padding(13)
                        .background(.ultraThinMaterial)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .frame(width: 50)
                    
                }
                
                ForEach(userDataStore.users,id: \.id){user in
                    VStack{
                        
                        
                        useImage(text: user.profileImage)
                            .resizable()
                            .scaledToFit()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .frame(width: 50)
                        Text(user.userName)
                            .foregroundColor(.white)
                            .fontWeight(.light)
                            .font(.system(size: 8))
                    }
                }
            }
        }
        .padding(.top,20)
        .padding(.leading)
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
                    .foregroundColor(.orange)
                Spacer()
            }
            .padding(.horizontal,20)
            
            HStack{
                Text("Contacts")
                    .fontWeight(.light)
                    .foregroundColor(.white)
                Text("(\(userDataStore.users.count))")
                    .fontWeight(.ultraLight)
                    .font(.callout)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal,18)
            .padding(.top,14)
            ListOfAllUsers
        }
        .padding(.top,34)
    }
    func useImage(text:String)->Image{
        let data = Data(base64Encoded: text) ?? Data()
        
        let uiImage = UIImage(data: data) ?? UIImage()
        
        return Image(uiImage: uiImage)
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserDataStore())
    }
}
