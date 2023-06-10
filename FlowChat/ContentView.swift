//
//  ContentView.swift
//  FlowChat
//
//  Created by aplle on 6/1/23.
//

import SwiftUI
import Firebase
struct ContentView: View {
    @State private var screen = UIScreen.main.bounds
    @EnvironmentObject var userDataStore:UserDataStore
    var body: some View {
        ZStack {
         
        MainView()
        .transition(.move(edge: .bottom))
             
               
        }
       
        .onAppear{
            userDataStore.fetchUsers()
        
     
        }
        .ignoresSafeArea()
        
        
    }
    var bacground:some View{

        return ZStack{
            Color.blue.colorMultiply(.pink).ignoresSafeArea()
            VStack{
                Spacer()
                Image("background1")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
            }
            .padding(.top)
            .ignoresSafeArea()
        }
    }
   
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
