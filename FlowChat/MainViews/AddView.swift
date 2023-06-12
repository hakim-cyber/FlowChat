//
//  AddView.swift
//  FlowChat
//
//  Created by aplle on 6/4/23.
//

import SwiftUI
import Firebase
struct AddView: View {
    @EnvironmentObject var userDataStore:UserDataStore
    @State private var participants = [User]()
    var addParticipants:([String],String) -> Void
    @State private var askForTitle = false
    @State private var title = ""
    @State private var screen = UIScreen.main.bounds.size
    let rows = [
           GridItem(.fixed(UIScreen.main.bounds.size.height / 14)),
           GridItem(.fixed(UIScreen.main.bounds.size.height / 14)),
           GridItem(.fixed(UIScreen.main.bounds.size.height / 14))
       ]
    var body: some View {
        ZStack{
            Color.black.clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack{
                HStack{
                    Button{
                        // close
                        addParticipants([String](),"")
                    }label: {
                        Image(systemName: "xmark")
                            
                            
                    }
                    Spacer()
                    Text("\(participants.count)")
                    Image(systemName: "person")
                    
                }
                .font(.system(size: screen.width / 35))
           
                ScrollView(.horizontal,showsIndicators: false){
                    LazyHGrid(rows: rows){
                        ForEach(userDataStore.users,id: \.id) { user in
                            VStack(spacing: 4){
                                useImage(text: user.profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .background(.white)
                                    .clipShape(Circle())
                                    .shadow(color:.orange, radius: participants.contains(where: {$0.id == user.id}) ? 8: 0)
                                   
                                Text(user.userName)
                                    .font(.system(size: 13))
                                    .fontWeight(.light)
                                    
                            }
                            
                            .frame(width: screen.height / 14)
                            .padding(.vertical,5)
                            .onTapGesture {
                                if participants.contains(where: {$0.id == user.id}){
                                    withAnimation(){
                                        participants.removeAll(where: {$0.id == user.id})
                                    }
                                }else{
                                    withAnimation(){
                                        participants.append(user)
                                    }
                                }
                            }
                        }
                    }
                }
                HStack{
                    Spacer()
                    Button{
                        if participants.count > 2{
                            self.askForTitle = true
                        }else{
                            addParticipants(usersId(users: participants),"")
                        }
                    }label: {
                        Text("Start Chat")
                            .padding(5)
                            .padding(.horizontal,5)
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(participants.count <= 1)
                }
            }
            .foregroundColor(.orange)
            .padding()
        }
        .frame(width: screen.width / 1.05,height: screen.height / 3 )
        .onAppear{
            addMe()
            self.title = ""
        }
        .alert("Chat Title", isPresented: $askForTitle){
            TextField("", text: $title)
            Button("Add"){
                addParticipants(usersId(users: participants),title)
                
               
            }
           
           
           
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                       
                   // Give a moment for the screen boundaries to change after
                   // the device is rotated
                   Task { @MainActor in
                       try await Task.sleep(for: .seconds(0.1))
                       withAnimation{
                           self.screen = UIScreen.main.bounds.size
                       }
                   }
               }
    }
    func useImage(text:String)->Image{
        let data = Data(base64Encoded: text) ?? Data()
        
        let uiImage = UIImage(data: data) ?? UIImage()
        
        return Image(uiImage: uiImage)
    }
    func addMe(){
        guard let uid  = Auth.auth().currentUser?.uid else{return}
        if let me = userDataStore.users.first(where: {$0.id == uid}){
            self.participants = []
            self.participants.append(me)
        }
    }
    func usersId(users:[User])->[String]{
        var ids = [String]()
        for user in users{
            ids.append(user.id ?? "")
        }
        return ids
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(){_ , _ in
            
        }
            .environmentObject(UserDataStore())
    }
}
