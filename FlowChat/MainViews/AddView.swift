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
    @State private var users = [User(id: UUID().uuidString,userName: "Hakim", profileImage: "", chats: [Chat]()),User(id: UUID().uuidString,userName: "Hakim", profileImage: "", chats: [Chat]()),User(id: UUID().uuidString,userName: "Hakim", profileImage: "", chats: [Chat]())]
    var addParticipants:([User]) -> Void
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
                        addParticipants([User]())
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
                        addParticipants(participants)
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
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(){_ in
            
        }
            .environmentObject(UserDataStore())
    }
}
