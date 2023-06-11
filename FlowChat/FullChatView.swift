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
            Color.white.ignoresSafeArea()
            
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
                .padding(.horizontal)
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
            HStack(spacing: 10){
                Button{
                    //features
                }label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.purple)
                        .frame(width: screen.width * 0.20/4)
                }
                TextField("Write Message", text: $newMessageText)
                    .padding()
                    .background(.thinMaterial)
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
            }
        }
    }
    @ViewBuilder
    func messageItem(message:Message) -> some View{
       return ZStack{
            if message.senderID == idOfuserUsingApp{
                Rectangle()
                    .fill(Color.blue)
                    .cornerRadius(30)
                    
                    
                    
            }else{
                Rectangle()
                    .fill(Color.black)
                    .cornerRadius(30)
            }
           VStack{
               HStack{
                   Text(message.content)
                       .padding(3)
                       .foregroundColor(.white)
               }
           }
           
           
           
        }
       .frame(maxWidth: screen.width / 2.5,maxHeight: screen.height / 2 ,alignment: .leading)
     
     
       
       
       
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
