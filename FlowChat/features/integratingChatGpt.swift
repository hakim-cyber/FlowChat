//
//  integratingChatGpt.swift
//  FlowChat
//
//  Created by aplle on 6/16/23.
//

import SwiftUI
import OpenAISwift
final class ChatGptViewModel:ObservableObject{
    init(){}
    private var client:OpenAISwift?
    func setup(){
        client = OpenAISwift(authToken: "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")
    }
    func send(text:String,completion:@escaping(String)->Void){
        client?.sendCompletion(with: text,maxTokens: 250 ,completionHandler: {result in
            switch result{
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                if output == ""{
                    print("Empty")
                }
                
                completion(output)
                print("good")
            case .failure(let error):
                print("error")
                print(error)
                break
            }
            
        })
    }
}
struct integratingChatGpt: View {
    var complete:(String)->Void
    @StateObject var viewModel = ChatGptViewModel()
    @State  var screen = UIScreen.main.bounds.size
    @State  var inputText = ""
    @FocusState var textFocused
    @State  var outputText = ""
    var body: some View {
        VStack{
            Spacer()
            VStack{
                HStack{
                    TextField("",text: $inputText,axis: .vertical)
                        .foregroundColor(.black)
                        .padding(10)
                        .lineLimit(3)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(.gray))
                        .focused(self.$textFocused)
                        
                    Button{
                        self.viewModel.send(text: inputText){text in
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut){
                                    self.outputText = text
                                    self.inputText = ""
                                    self.textFocused = false
                                }
                            }
                           
                        }
                    }label: {
                        Text("✈️")
                            .padding(10)
                            .background(Circle().stroke(.blue))
                            
                    }
                }
                
               
                ScrollView(.vertical,showsIndicators: false){
                    VStack{
                        Text(self.outputText)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal,15)
               
                }
                Spacer()
                Button{
                    // next
                  complete(outputText)
                }label: {
                    if  self.outputText == ""{
                       
                        Text("Back")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    
                    }else{
                        Text("Done")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    }
                
                       
                        
                }
                .buttonStyle(.borderedProminent)
                .tint( self.outputText == "" ? .orange : .blue)
                .padding(.vertical,5)
                
                
            }
            .padding()
            .foregroundColor(.black)
            .frame(maxWidth: .infinity,maxHeight:.infinity)
            .background(.white)
            .roundedCorner(25, corners: [.topLeft,.topRight])
            .frame(width: screen.width,height:  textFocused == true ? screen.height * 0.50 : screen.height * 0.35 )
        }
        .foregroundColor(.black)
        .ignoresSafeArea()
        .onAppear{
            viewModel.setup()
        }
    }
}

struct integratingChatGpt_Previews: PreviewProvider {
    static var previews: some View {
        integratingChatGpt(){_ in
            
        }
    }
}
