//
//  MessageItemView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct MessageListView: View {
    @StateObject var viewModel: ChatMessageViewModel
    
    var partnerId: String
    var uid: String
    
    static let emptyScrollToString = "Empty"
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    ForEach(viewModel.chatMessages) { chatMessage in
                        MessageItemView(messageModel: ChatMessageModel(date: chatMessage.date, imageURL: chatMessage.imageURL, location: chatMessage.location, message: chatMessage.message, sender: chatMessage.sender), partnerId: partnerId, uid: uid)
                    }
                    HStack {
                        Spacer()
                    }
                        .id(Self.emptyScrollToString)
                }
                // 자동 스크롤
                .onReceive(viewModel.$count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                    }
                }
            }
        }
//        .background(Color(.init(white: 0.95, alpha: 1)))
    }
}
