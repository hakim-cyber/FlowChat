//
//  StartView.swift
//  FlowChat
//
//  Created by aplle on 6/2/23.
//

import SwiftUI
enum AuthTypes:String{
case login,register,none
}

struct StartView: View {
    @AppStorage("authType") var authType:String = AuthTypes.none.rawValue
    
    var body: some View {
        ZStack{
            background
            
               
            if authType != AuthTypes.none.rawValue{
                if authType == AuthTypes.login.rawValue{
                    LoginView()
                        .transition(.move(edge: .top))
                }else{
                    RegisterView()
                        .transition(.move(edge: .top))
                }
            }else{
                content
            }
                   
            
         
        }
    }
    var background:some View{

        return ZStack{
            Image("photo11")
                .resizable()
                .ignoresSafeArea()
         
        }
        .ignoresSafeArea()
    }
    var content:some View{
        VStack{
            HStack{
                VStack(alignment: .leading, spacing: 5){
                    Text("Elevate")
                    Text("messaging")
                        .foregroundColor(Color.orange)
                    Text("capabilities")
              
                }
                
                    Spacer()
            }
            .foregroundColor(.white)
            .font(.system(size: 50))
            .fontDesign(.rounded)
            .fontWeight(.bold)
            
            
            ScrollView(.vertical){
              scrolltem(image: Image(systemName: "theatermasks.fill"), text: "Joke Generator")
                scrolltem(image: Image(systemName: "text.bubble.fill"), text: "AI Text Generator")
                scrolltem(image: Image(systemName: "arrow.2.squarepath"), text: "Task Automation")
                scrolltem(image: Image(systemName: "calendar.badge.clock"), text: "Schedule Tasks")
                scrolltem(image: Image(systemName: "lasso.and.sparkles"), text: "Interactive Design")
                
            }
            HStack(spacing: 10){
                Button{
                    //login
                    withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.6)){
                        authType = AuthTypes.login.rawValue
                    }
                }label: {
                    Text("Login")
                        .padding(20)
                        .foregroundColor(.white)
                        .padding(.horizontal,40)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
              
                Button{
                    //register
                    withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.6)){
                        authType = AuthTypes.register.rawValue
                    }
                }label: {
                    Text("Register")
                        .foregroundColor(.black)
                        .padding()
                        .padding(.horizontal,30)
                        .background(in: Capsule())
                }
            }
            Spacer()
            
            
            
            
        }
        .transition(.move(edge: .bottom))
        .padding([.top,.horizontal])
       
    }
    func scrolltem(image:Image,text:String) -> some View{
        ZStack{
            RoundedRectangle(cornerRadius: 28,style: .continuous)
                .fill(.thinMaterial)
            
            VStack{
                HStack(spacing: 15){
                    image
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Text("\(text)")
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(.vertical,10)
            .padding(.horizontal,10)
        }
    }
    
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
