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
    var body: some View {
        ZStack{
            
        }
        .onAppear{
                       Auth.auth().addStateDidChangeListener{auth,user in
                           if user != nil{
                               withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.6)){
                                   userLogedIn = true
                           }
                           }
                       }
                   }
        .transition(.move(edge: .bottom))
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
