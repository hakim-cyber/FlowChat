//
//  UserInformationView.swift
//  FlowChat
//
//  Created by aplle on 6/2/23.
//

import SwiftUI
import Firebase


struct UserInformationView: View {
    @EnvironmentObject var userDataStore:UserDataStore
    
    
    @State private var userName = ""
    @State private var image:UIImage?
    @State private var showPicker = false
    
    @State private var InfoAdded = false
    
    var body: some View {
        ZStack{
            if InfoAdded {
                ContentView()
            }else{
                VStack(spacing: 40){
                    Spacer()
                    TextField("Username", text: $userName)
                        .padding()
                        .background(.thinMaterial)
                        .foregroundColor( .white)
                        .cornerRadius(30)
                        .shadow(color:.gray,radius: 5)
                        .padding(.horizontal,20)
                        .padding(.vertical,2)
                    
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .background(.black)
                        .clipShape(Circle())
                        .frame(width: 200)
                        .onTapGesture {
                            showPicker.toggle()
                        }
                    Spacer()
                    Button{
                       addUserInfo()
                    }label: {
                        Text("Next")
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 300,height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 40,style: .continuous)
                                    .fill(Color.blue)
                                    .shadow(radius: 5)
                            )
                            .padding()
                    }
                    .disabled(userName == "" || image == nil)
                }
                .sheet(isPresented: $showPicker){
                    ImagePicker(image: $image)
                }
                .onAppear{
                   
                  checkInforationIsAdded()
                  
                }
            }
        }
    }
    func addUserInfo() {
        guard let uidOfUser = Auth.auth().currentUser?.uid else { return }
        
        guard let image = image, let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("Error: Unable to get image or convert to data")
            return
        }
        
        let resizedImage = image.resize(to: CGSize(width: 500, height: 500)) // Adjust the desired size
        
        guard let resizedImageData = resizedImage!.jpegData(compressionQuality: 0.75) else {
            print("Error: Unable to resize image or convert to data")
            return
        }
        
        let imageString = resizedImageData.base64EncodedString()
        
        let user = User(id: uidOfUser, userName: userName, profileImage: imageString, chats: [])
        
        userDataStore.updateorAddUser(user: user)
      
        
       checkInforationIsAdded()
        
    }
    func checkInforationIsAdded(){
               guard let uid = Auth.auth().currentUser?.uid else{return}
               let db = Firestore.firestore()
               let docRef = db.collection("users").document(uid)
               
               docRef.getDocument { (document, error) in
                   if error != nil{
                       print(error?.localizedDescription as Any)
                      
                       return
                       
                   }
                   if let document = document{
                       
                       if document.exists {
                          
                           withAnimation(.interactiveSpring()){
                               self.InfoAdded = true
                           }
                       } else {
                         
                           return
                         
                       }
                   }else{
                     
                       return
                   }
                   
                
               }
    }
}

struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationView()
            .environmentObject(UserDataStore())
    }
}



import UIKit

extension UIImage {
    func resize(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
