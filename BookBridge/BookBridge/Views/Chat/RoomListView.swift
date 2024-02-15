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
                ZStack {
                    NavigationLink {
                        ChatMessageView(chatRoomListId: chatRoom.id, isFirst: false, noticeBoardTitle: chatRoom.noticeBoardTitle, partnerId: chatRoom.partnerId, partnerImageURL: viewModel.getPartnerImageIndex(partnerId: chatRoom.partnerId, noticeBoardId: chatRoom.noticeBoardId), uid: chatRoom.userId)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0.0)
                    
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: viewModel.getPartnerImageIndex(partnerId: chatRoom.partnerId, noticeBoardId: chatRoom.noticeBoardId))) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(.label), lineWidth: 1)
                                )
                        } placeholder: {
                            // Placeholder 이미지 설정
                            Image("DefaultImage")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
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
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    ChatRoomListView(uid: "lee")
}
