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
    @State private var chatsForUser = [Chat]()
    @State private var selectedChatId:Int?
    @State private var chatTitle = ""
    @State private var showFullChat = false
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("background") var background = 1
    var currentUserData:User{
        guard let uid = Auth.auth().currentUser?.uid else{return User(userName: "non", profileImage: "", chatsIds: [String]())}
       
        
        if let user = userDataStore.users.first(where: {$0.id == uid}){
            return user
        }else{
            return User(userName: "non", profileImage: "", chatsIds: [String]())
        }
    }
    var body: some View {
        ZStack{
            Image("photo\(background)")
                .resizable()
                .frame(width: screen.width , height: screen.height)
                .ignoresSafeArea()
                
            
        }
        
        .padding(.top)
        .overlay(alignment: .bottom, content: {
            
                content
                    .transition(.move(edge: .top))
            
        })
        .overlay(alignment: .top){
            header
        }
        .overlay{
            if showAddView{
                AddView(){participants , title in
                    if participants.count <= 1{
                      // nothing to do
                        withAnimation(.easeInOut(duration: 0.3)){
                           
                                showAddView.toggle()
                            
                        }
                    }else{
                        // add new chat with participants
                        withAnimation(.easeInOut(duration: 0.3)){
                           
                                self.userDataStore.addChat(participantIds: participants, title: title)
                            
                                showAddView.toggle()
                            
                        }
                    }
                }
                .transition(.move(edge: .trailing))
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showFullChat,onDismiss: {
            self.selectedChatId = nil
            DispatchQueue.global().async {
                if self.userDataStore.messageListener.first != nil{
                    self.userDataStore.messageListener.first?.remove()
                }
            }
          
            
        }){
            if selectedChatId != nil{
                if userDataStore.chatsForUser[selectedChatId!] != nil{
                    FullChatView(chat:userDataStore.chatsForUser[selectedChatId!] )
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                       
                   // Give a moment for the screen boundaries to change after
                   // the device is rotated
                   Task { @MainActor in
                       try await Task.sleep(for: .seconds(0.1))
                       withAnimation {
                           self.screen = UIScreen.main.bounds.size
                       }
                   }
               }
       
       
    }
    var content:some View{
        
        VStack{
            Spacer()
            ScrollView(.vertical,showsIndicators: false){
               
                VStack(spacing: 10){
                    ForEach(userDataStore.chatsForUser, id:\.id){chat in
                        VStack(){
                            chatItemView(chat: chat)
                                .environmentObject(userDataStore)
                                .padding(.bottom)
                                .onTapGesture {
                                    if let index = userDataStore.chatsForUser.firstIndex(where: {$0.id == chat.id}){
                                        self.selectedChatId = index
                                        self.showFullChat = true
                                    }
                                }
                        }
                    }
                    
                }
                .padding(.top,15)
                .padding(.vertical,20)
            }
            .frame(maxWidth: .infinity,maxHeight:.infinity,alignment:.bottom)
           
        }
       
        .background(colorScheme == .light ? .white: .gray)
        .roundedCorner(35, corners: [.topLeft,.topRight])
        .frame(width: screen.width,height: screen.height * 0.60)
      
        .ignoresSafeArea()
       
        
       
    }
    var ListOfAllUsers:some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack(alignment: .top,spacing: 5){
                Button{
                    // new chat
                    withAnimation(.easeInOut(duration: 0.3 )){
                       
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
    var customMenu:some View{
        Menu{
            Button{
              //schedule message
            }label: {
                HStack{
                   
                    Image(systemName: "calendar.badge.clock")
                    
                    Text("Schedule Message")
                }
            }
            Menu{
                Menu{
                    Picker("",selection: $background){
                        ForEach(1...11,id: \.self){
                           Text("photo \($0)")
                                .id($0)
                        }
                    }
                    .labelsHidden()
                }label: {
                    Text("Background")
                    Image(systemName: "photo.tv")
                }
            }label: {
                Text("Settings")
                Image(systemName: "gear")
            }
        }label: {
            Image(systemName: "filemenu.and.cursorarrow")
                .bold()
                .foregroundColor(.white)
        }
    }
    var header:some View{
        VStack(spacing: 5){
            HStack{
                Text("Hi,\(currentUserData.userName)")
                    .foregroundColor(.gray)
                    .font(.callout)
                Spacer()
               customMenu
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
        .frame(width: screen.width,height: screen.height * 0.40)
        .padding(.horizontal)
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
