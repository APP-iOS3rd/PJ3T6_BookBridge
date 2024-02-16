//
//  ChatMessageView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatMessageView: View {
    @StateObject var viewModel = ChatMessageViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var isPlusBtn = true
    @FocusState var isShowKeyboard: Bool

    var chatRoomListId: String
    var isFirst: Bool                   //true: 채팅 한번 안함, false: 이미 방이있음
    var noticeBoardTitle: String
    var partnerId: String
    var partnerImageURL: String
    var uid: String
    
    var body: some View {
        VStack {
            noticeBoardChatView()
            MessageListView(viewModel: viewModel, partnerId: partnerId, partnerImageURL: partnerImageURL, uid: uid)
            ChatBottomBarView(viewModel: viewModel, isShowKeyboard: $isShowKeyboard, isPlusBtn: $isPlusBtn, chatRoomListId: chatRoomListId, partnerId: partnerId, uid: uid)
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
                isPlusBtn = true
            }
            isShowKeyboard = false
        }
        .transition(.move(edge: .bottom))
        //        .navigationTitle(noticeBoardTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                VStack {
                    HStack {
                        Image(systemName: "graduationcap.fill")
                            .font(.caption)
                            .foregroundStyle(.black)
                        Text("동네보안관")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    Text(noticeBoardTitle)
                        .font(.headline)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            viewModel.initNewCount(uid: uid, chatRoomId: chatRoomListId)
            viewModel.fetchMessages(uid: uid, chatRoomListId: chatRoomListId)
        }
        .onDisappear {
            viewModel.firestoreListener?.remove()
        }
    }
}
