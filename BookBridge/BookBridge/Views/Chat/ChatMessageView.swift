//
//  ChatLogView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatMessageView: View {
    @StateObject var viewModel = ChatMessageViewModel()
    
    var chatRoomListId: String
    var isFirst: Bool                   //true: 채팅 한번 안함, false: 이미 방이있음
    var noticeBoardTitle: String
    var partnerId: String
    var uid: String
    
    var body: some View {
        VStack {
            MessageListView(viewModel: viewModel, partnerId: partnerId, uid: uid)
            ChatBottomBarView(viewModel: viewModel, chatRoomListId: chatRoomListId, partnerId: partnerId, uid: uid)
        }
        .navigationTitle(noticeBoardTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMessages(uid: uid, chatRoomListId: chatRoomListId)
        }
        .onDisappear {
            viewModel.firestoreListener?.remove()
        }
    }
}
