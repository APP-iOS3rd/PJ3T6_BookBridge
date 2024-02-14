//
//  ChatBottomBarView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct ChatBottomBarView: View {
    @StateObject var viewModel: ChatMessageViewModel
    
    var chatRoomListId: String
    var partnerId: String
    var uid: String
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(.darkGray))
            }
            ZStack {
                HStack {
                    Text("내용을 입력해주세요")
                        .foregroundColor(Color(.gray))
                        .font(.system(size: 17))
                        .padding(.leading, 5)
                        .padding(.top, -4)
                    Spacer()
                }
                
                TextEditor(text: $viewModel.chatText)
                    .opacity(viewModel.chatText.isEmpty ? 0.5 : 1)
            }
//            .overlay(
//                RoundedRectangle(cornerRadius: 18)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
            .frame(height: 40)
            
            Button {
                viewModel.handleSend(uid: uid, partnerId: partnerId, chatRoomListId: chatRoomListId)
            } label: {
                Image(systemName: "paperplane")
                    .font(.system(size: 24))
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
