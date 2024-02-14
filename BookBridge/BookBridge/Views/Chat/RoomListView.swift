//
//  RoomListView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct RoomListView: View {
    @StateObject var viewModel: ChatRoomListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.chatRoomList) { chatRoom in
                NavigationLink {
                    ChatMessageView(chatRoomListId: chatRoom.id, isFirst: false, noticeBoardTitle: chatRoom.noticeBoardTitle, partnerId: chatRoom.partnerId, uid: chatRoom.userId)
                } label: {
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color(.label), lineWidth: 1)
                                )
                        } placeholder: {
                            // Placeholder 이미지 설정
                            ProgressView()
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text(chatRoom.noticeBoardTitle)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color(.label))
                                .multilineTextAlignment(.leading)
                            Text(chatRoom.recentMessage)
                                .font(.system(size: 14))
                                .foregroundStyle(Color(hex:"8A8A8E"))
                                .multilineTextAlignment(.leading)
                                .lineLimit(2) // 두 줄까지만 표시
                                .truncationMode(.tail) // 뒤에는 ...으로 표시
                        }
                        Spacer()
                        
                        Text(chatRoom.timeAgo)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color(.lightGray))
                    }
                }

                /*
                VStack {
                    Button {
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                        self.chatUser = .init(data: [
                            FirebaseConstants.email: recentMessage.email,
                            FirebaseConstants.profileImageUrl: recentMessage.profileImageUrl,
                            FirebaseConstants.uid: uid
                        ])
                        self.chatLogViewModel.chatUser = self.chatUser
                        self.chatLogViewModel.fetchMessages()
                        self.navigateToChatLogView.toggle()
                    } label: {
                        
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let chatUserID = chatUser?.uid {
                                chatListVM.deleteChatList(chatUserID: chatUserID)
                            }
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                    Divider()
                }
                 */
            }
            
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}
