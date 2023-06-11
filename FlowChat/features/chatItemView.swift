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
    var body: some View {
        HStack( spacing: 5){
        images
            
               
                
            VStack(alignment: .leading){
               names
                Spacer()
                Text("latest message")
                    .font(.callout)
                    .fontWeight(.ultraLight)
                    .foregroundColor(.black)
            }
            .padding(.vertical,10)
            .padding(.leading,10)
            Spacer()
            VStack{
                Text("10:00 am")
                    .font(.caption)
                    .fontWeight(.ultraLight)
                    .foregroundColor(.black)
                Spacer()
                Text("✓")
                    .fontWeight(.medium)
                    .foregroundColor(.purple)
            }
            .padding(.vertical,10)
            
        }
        
        .frame(width: screen.width / 1.10, height: screen.height / 24)
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
        .foregroundColor(.black)
       
    }
    var images:some View{
        ZStack{
            ForEach(participants, id: \.id){user in
                useImage(text: user.profileImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(height: screen.height / ( 24 ))
                    .offset(x:offsetForImage(user: user))
            }
        }
        .frame(height: screen.height / 24)
        .padding(.vertical,10)
        .padding(.trailing)
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
}

struct chatItemView_Previews: PreviewProvider {
    static var previews: some View {
        chatItemView(chat: Chat(participantsID: [UUID().uuidString,UUID().uuidString]))
            .environmentObject(UserDataStore())
    }
}
