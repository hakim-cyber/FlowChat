//
//  ContentView.swift
//  FlowChat
//
//  Created by aplle on 6/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var screen = UIScreen.main.bounds
    @EnvironmentObject var userDataStore:UserDataStore
    var body: some View {
        ZStack {
          bacground
               
        }
        .onAppear{
            userDataStore.fetchUsers()
     
        }
        .ignoresSafeArea()
        
        
    }
    var bacground:some View{

        return ZStack{
            Color.background
            VStack{
                Spacer()
                Image("background1")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .transition(.move(edge: .bottom))
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
