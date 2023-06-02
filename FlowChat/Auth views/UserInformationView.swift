//
//  UserInformationView.swift
//  FlowChat
//
//  Created by aplle on 6/2/23.
//

import SwiftUI

struct UserInformationView: View {
    @State private var userName = ""
    @State private var image:UIImage?
    @State private var showPicker = false
    var body: some View {
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
                .frame(width: 100)
                .onTapGesture {
                    showPicker.toggle()
                }
            Spacer()
            Button{
              // add user info to firestore
            }label: {
                Text("Next")
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 300,height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 40,style: .continuous)
                            .fill(Color.indigo)
                            .shadow(radius: 5)
                    )
                    .padding()
            }
            .disabled(userName == "" || image == nil)
        }
        .sheet(isPresented: $showPicker){
            ImagePicker(image: $image)
        }
    }
}

struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationView()
    }
}
