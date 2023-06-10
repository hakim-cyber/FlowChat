//
//  chatItemView.swift
//  FlowChat
//
//  Created by aplle on 6/10/23.
//

import SwiftUI

struct chatItemView: View {
    var chat:Chat
    @State private var screen = UIScreen.main.bounds.size
    var body: some View {
        HStack{
           RoundedRectangle(cornerRadius: 15)
        }
        .frame(width: screen.width / 1.1, height: screen.height / 14)
    }
}

struct chatItemView_Previews: PreviewProvider {
    static var previews: some View {
        chatItemView(chat: Chat(participantsID: [UUID().uuidString,UUID().uuidString]))
    }
}
