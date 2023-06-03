//
//  LoginView.swift
//  FlowChat
//
//  Created by aplle on 6/2/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @AppStorage("userLogedIn") var userLogedIn = false
    @AppStorage("InfoAdded")  var InfoAdded = false
    @State private var error = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isEmailValid = false
    var body: some View {
        ZStack{
          if userLogedIn{
                ContentView()
            }else{
                
                ZStack{
                    VStack(spacing: 20){
                        HStack{
                            Text("Login")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                                .fontDesign(.rounded)
                                .fontWeight(.bold)
                            
                            
                        }
                        Spacer()
                        TextField("Email", text: $email)
                            .padding()
                            .background(.thinMaterial)
                            .foregroundColor(isEmailValid ? .white: .red)
                            .cornerRadius(30)
                            .shadow(color:.gray,radius: 5)
                            .padding(.horizontal,20)
                            .padding(.vertical,2)
                        
                            .onChange(of: email){ newEmail in
                                validateEmail(email: newEmail)
                            }
                        
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(.thinMaterial)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .shadow(color:.gray,radius: 5)
                            .padding(.horizontal,20)
                            .padding(.vertical,2)
                       
                        
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        Spacer()
                        Spacer()
                        Button{
                            login()
                        }label: {
                            Text("Log In")
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
                        .disabled(!isEmailValid)
                    }
                    .padding(.horizontal)
                }
                .onAppear{
                    Auth.auth().addStateDidChangeListener{auth,user in
                        if user != nil{
                            withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.6)){
                                userLogedIn = true
                                InfoAdded = true
                            }
                        }
                    }
                }
                .transition(.move(edge: .bottom))
           
            }
        
        }
        
    }
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){result , error in
            if error != nil{
                self.error = (error?.localizedDescription ?? "") as String
            }
        }
    }
    private func validateEmail(email: String) {
               let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
               let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
               isEmailValid = emailPredicate.evaluate(with: email)
           }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
