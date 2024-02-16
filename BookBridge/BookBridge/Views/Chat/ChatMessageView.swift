//
//  ChatMessageView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatMessageView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = ChatMessageViewModel()
    
    var chatRoomListId: String
    var noticeBoardId: String
    var noticeBoardTitle: String
    var partnerId: String
    var partnerImage: UIImage
    var uid: String
    
    var body: some View {
        VStack {
            noticeBoardChatView(viewModel: viewModel)
            
            MessageListView(viewModel: viewModel, partnerId: partnerId, partnerImage: partnerImage, uid: uid)
            
            ChatBottomBarView(viewModel: viewModel, chatRoomListId: chatRoomListId, partnerId: partnerId, uid: uid)
        }
//        .navigationTitle(noticeBoardTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.firestoreListener?.remove()
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
            viewModel.getNoticeBoardInfo(noticeBoardId: noticeBoardId)
        }
    }
}
