//
//  ChatLogView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    @State var chatText = ""
    
    @ObservedObject var chatLogVM = ChatLogViewModel()
    
    var body: some View {
        VStack {
            messagesView
            chatBottomBar
        }
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10) { num in
                HStack {
                    Spacer()
                    HStack {
                        Text("FAK MESSAGE FOR NOW")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            HStack {
                Spacer()
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundStyle(Color(.darkGray))
            TextField("Description", text: $chatText)
            Button {
                chatLogVM.handleSend(text: self.chatText)
            } label: {
                Text("Send")
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        ChatLogView(chatUser: .init(data: ["uid": "IFIoThJg7DPvxdS5CaCDfHzUeFl2", "email": "testchat@chat.com"]))
    }
}
