//
//  FullChatView.swift
//  FlowChat
//
//  Created by aplle on 6/10/23.
//

import SwiftUI
import Firebase

struct FullChatView: View {
    @EnvironmentObject var userDataStore:UserDataStore
    var chat:Chat
    @State private var messages = [Message]()
    @State private var newMessageText = ""
    @State private var screen = UIScreen.main.bounds.size
    var idOfuserUsingApp:String{
        guard let userusingAppId = Auth.auth().currentUser?.uid else{return ""}
        return userusingAppId
    }
    var chatMain:Chat?{
        self.userDataStore.chatsForUser.first(where: {$0.id == chat.id})
    }
    var sortedMessages:[Message]{
     return   messages.sorted{stringToDate(string: $0.date) < stringToDate(string: $1.date)}
    }
    var body: some View {
        
        ZStack{
            Image("photo10")
                .resizable()
                .ignoresSafeArea()
            
            ScrollView{
                VStack(spacing: 30){
                    ForEach(sortedMessages, id:\.id){message in
                        HStack{
                            if message.senderID == idOfuserUsingApp{
                                Spacer()
                            }
                            messageItem(message: message)
                            if message.senderID != idOfuserUsingApp{
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal,10)
                .padding(.vertical,20)
            }
            .frame(maxWidth: .infinity , maxHeight: .infinity , alignment: .top)
                
        }
        .onAppear{
            if chatMain != nil{
                userDataStore.fetchMessagesForChat(chat: chatMain!){messages in
                    self.messages = messages
                }
            }
        }
        .onChange(of: chatMain?.messagesID.count){_ in
            if chatMain != nil{
                userDataStore.fetchMessagesForChat(chat: chatMain!){messages in
                    self.messages = messages
                }
            }
        }
        .safeAreaInset(edge: .bottom){
            HStack(alignment: .center,spacing: 10){
               
                    
                    Button{
                        //features
                    }label: {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.purple)
                            .frame(width: screen.width * 0.20/4)
                    }
                  
                
               
                    TextField("Write Message", text: $newMessageText,axis:.vertical)
                        .padding()
                        .background(.thinMaterial)
                        .lineLimit(4)
                        .cornerRadius(10)
                        .shadow(color:.gray,radius: 5)
                        .frame(width: screen.width / 1.3)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.leading)
                        
                
              
                    Button{
                        //send
                        sendMessage()
                    }label: {
                        Image(systemName: "airplane.departure")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.purple)
                            .frame(width: screen.width * 0.20/3)
                    }
                    .disabled(newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
            }
        }
    }
    @ViewBuilder
    func messageItem(message:Message) -> some View{
        return ZStack{
            HStack{
                useImage(text: idToUser(id: message.senderID).profileImage)
                    .resizable()
                    .scaledToFit()
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .frame(width: 30)
                VStack(alignment: .leading){
                    
                    Text(message.content.trimmingCharacters(in: .whitespacesAndNewlines))
                        .foregroundColor(.white)
                    
                    HStack{
                        Spacer()
                        Text("\(stringToDate(string: message.date).formatted(date: .omitted, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.white)
                            .fontWeight(.ultraLight)
                    }
                }
                .padding(7)
                .padding(.horizontal,7)
                .background(
                    Rectangle()
                        .fill(message.senderID == idOfuserUsingApp ? Color.blue : Color.black)
                        .cornerRadius(15)
                    
                )
            }
                
                
                
           
            
           
           
           
        }
       .frame(maxWidth: screen.width / 2.2,maxHeight: screen.height / 2 )
     
     
       
       
       
    }
    func idToUser(id:String)->User{
        if let user = self.userDataStore.users.first(where: {$0.id == id}){
            return user
        }else{
            return User(userName: "None", profileImage: "", chatsIds: [])
        }
    }
    func dateToString(date:Date)->String{
        let dateFormatter = DateFormatter()

        // Convert Date to String
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
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
    func sendMessage(){
        let messageId = UUID().uuidString
           let message = Message(id: messageId, senderID: idOfuserUsingApp, content: newMessageText, date: dateToString(date: Date.now))
           
        DispatchQueue.global().async {
               userDataStore.addMessage(message: message, to: chat)
               
               DispatchQueue.main.async {
                   self.newMessageText = ""
               }
           }
    }
}

struct FullChatView_Previews: PreviewProvider {
    static var previews: some View {
        FullChatView(chat: Chat(participantsID: [UUID().uuidString]))
            .environmentObject(UserDataStore())
    }
}
