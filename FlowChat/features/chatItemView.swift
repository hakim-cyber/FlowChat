//
//  chatItemView.swift
//  FlowChat
//
//  Created by aplle on 6/10/23.
//

import SwiftUI
import Firebase
struct chatItemView: View {
    @EnvironmentObject var userStore:UserDataStore
    var chat:Chat
    @State private var screen = UIScreen.main.bounds.size
    
    var participants:[User]{
        guard let uid = Auth.auth().currentUser?.uid else{return [User]()}
        var users = [User]()
        for id in chat.participantsID{
            if let user = self.userStore.users.first(where: {$0.id == id}){
                users.append(user)
            }
        }
        
        users.removeAll(where: {$0.id == uid })
        return users
    }
    @State private var lastMessage:Message?
    var body: some View {
        HStack( spacing: 5){
        images
            
               
                
            VStack(alignment: .leading){
               names
                Spacer()
                if lastMessage != nil{
                    Text("\(lastMessage!.content)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical,10)
            .padding(.leading,10)
            Spacer()
            VStack{
                if lastMessage != nil{
                    Text("\(stringToDate(string: lastMessage!.date).formatted(date: .omitted, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
               
            }
            .padding(.vertical,10)
            
        }
        
        .frame(width: screen.width / 1.15, height: screen.height / 25)
        .padding(5)
       
        
        .onAppear{
            self.userStore.fetchLastMessages{
                self.fetchLastMessage()
            }
        }
        .onChange(of: self.chat.messagesID.count){ _ in
            self.userStore.fetchLastMessages{
                self.fetchLastMessage()
            }
        }
    }
     
    var names:some View{
        HStack{
            if participants.count > 1{
                Text("\(chat.title ?? "")")
                    .fontWeight(.medium)
                    .font(.callout)
            }else{
                Text("\(participants.first?.userName ?? "")")
            }
            
        }

       
    }
    var images:some View{
        ZStack{
            ForEach(participants, id: \.id){user in
                useImage(text: user.profileImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(height: screen.height / ( 20 ))
                    .offset(x:offsetForImage(user: user))
            }
        }
        .frame( height: screen.height / 20)
        .padding(.trailing)
    }
    func stringToDate(string:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let reverseDate = dateFormatter.date(from: string)
        return reverseDate ?? Date.now
       
    }
    func useImage(text:String)->Image{
        let data = Data(base64Encoded: text) ?? Data()
        
        let uiImage = UIImage(data: data) ?? UIImage()
        
        return Image(uiImage: uiImage)
    }
    func offsetForImage(user:User)->CGFloat{
        if let index = participants.firstIndex(where: {$0.id == user.id}){
            return CGFloat(index * 10)
        }else{
            return CGFloat.zero
        }
    }
    func fetchLastMessage(){
        withAnimation{
            self.lastMessage = self.userStore.lastMessages[chat.id!] ?? nil
        }
    }
}

struct chatItemView_Previews: PreviewProvider {
    static var previews: some View {
        chatItemView(chat: Chat(id:"",title: "Hakim",participantsID: [UUID().uuidString,UUID().uuidString]))
            .environmentObject(UserDataStore())
    }
}
