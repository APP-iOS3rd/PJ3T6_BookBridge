//
//  ChatLogView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    static let emptyScrollToString = "Empty"
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.chatLogVM = .init(chatUser: chatUser)
    }
    
    @ObservedObject var chatLogVM: ChatLogViewModel
    
    var body: some View {
        VStack {
            ZStack {
                messagesView
                Text(chatLogVM.errorMessage)
            }
            chatBottomBar
        }
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        // 최근 메세지 자동 스크롤
//        .navigationBarItems(trailing: Button(action: {
//            chatLogVM.count += 1
//        }, label: {
//            Text("Count: \(chatLogVM.count)")
//        }))
    }
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader { ScrollViewProxy in
                VStack {
                    ForEach(chatLogVM.chatMessages) { message in
                        MessageView(message: message)
                    }
                    HStack { Spacer() }
                        .id(Self.emptyScrollToString)
                }
                .onReceive(chatLogVM.$count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        ScrollViewProxy.scrollTo("Empty", anchor: .bottom)
                    }
                }
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    // 메세지 입력 부분
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundStyle(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $chatLogVM.chatText)
                    .opacity(chatLogVM.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                chatLogVM.handleSend(text: chatLogVM.chatText)
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

// 메세지 풍선
struct MessageView: View {
    
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color(hex:"59AAE0"))
                    .cornerRadius(10)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color(hex:"767676"))
                    .cornerRadius(10)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
//        ChatLogView(chatUser: .init(data: ["uid": "IFIoThJg7DPvxdS5CaCDfHzUeFl2", "email": "testchat@chat.com"]))
        ChatListView()
    }
}
