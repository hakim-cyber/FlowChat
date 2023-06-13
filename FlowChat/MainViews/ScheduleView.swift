//
//  ScheduleView.swift
//  FlowChat
//
//  Created by aplle on 6/13/23.
//
import SwiftUI

struct ScheduleView: View{
    var complete:()->Void
    
   @State private var selectedChatId = ""
  
 
    
    @EnvironmentObject var userDataStore:UserDataStore
    @State private var screen = UIScreen.main.bounds.size
  
    @State private var text = ""
    @State private var date:Date = Date.now
    @State private var currentState = 1
   
    var body: some View {
        VStack{
            Spacer()
            VStack{
                HStack{
                    Button("↩︎"){
                        complete()
                    }
                    .font(.title)
                    Spacer()
                    Text("Schedule")
                        .fontWeight(.bold)
                        .font(.title2)
                        .fontDesign(.rounded)
                    Spacer()
                }
                if currentState == 1{
                    Spacer()
                    HStack{
                        Picker("to:",selection: $selectedChatId){
                            ForEach(userDataStore.chatsForUser,id:\.id){chat in
                                Text("\(chat.title ?? "")")
                                    .id(chat.id!)
                                    .foregroundColor(.black)
                                  
                            }
                        }
                       
                    }
                    .transition(.move(edge: .trailing))
                }else if currentState == 2{
                    VStack{
                        Text("Text :")
                        TextField("",text: $text,axis: .vertical)
                            .foregroundColor(.black)
                            .lineLimit(3)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 15).stroke(.gray))
                           
                            
                    }
                    .padding(.top,10)
                    .transition(.move(edge: .trailing))
                  
                }else if currentState == 3{
                    Spacer()
                    HStack{
                        DatePicker("", selection: $date)
                            .labelsHidden()
                            .frame(width: screen.width / 1.2,height: screen.height * 0.18)
                            .background(RoundedRectangle(cornerRadius: 15).fill(.black))
                            .datePickerStyle(.wheel)
                           
                        
                    }
                    .transition(.move(edge: .trailing))
                   
                }else{
                    
                }
               
                Spacer()
                Button{
                    // next
                    if currentState != 3{
                        withAnimation(.easeInOut(duration: 0.3 )){
                            
                            currentState += 1
                            
                        }
                    }else{
                        complete()
                    }
                }label: {
                    Text("Next")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        
                }
                .disabled(checkDisable())
                .buttonStyle(.borderedProminent)
                .padding(.bottom,10)
            }
            .padding()
            .foregroundColor(.black)
            .frame(maxWidth: .infinity,maxHeight:.infinity)
            .background(.white)
            .roundedCorner(35, corners: [.topLeft,.topRight])
            .frame(width: screen.width,height: screen.height * 0.30)
           
        }
        .onAppear{
            self.selectedChatId = self.userDataStore.chatsForUser.first?.id ?? ""
        }
        .ignoresSafeArea()
      
       
    }
    func checkDisable()->Bool{
        if currentState == 1 {
            if self.selectedChatId == ""{
                return true
            }else{
                return false
            }
                
        }else if currentState == 2{
            if self.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                return true
            }else{
                return false
            }
        }else if currentState == 3{
            return false
        }else{
            return true
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(){
            
        }
            .preferredColorScheme(.dark)
            .environmentObject(UserDataStore())
            
    }
}
