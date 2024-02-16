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
            ForEach(viewModel.searchChatRoomList()) { chatRoom in
                ZStack {
                    NavigationLink {
                        ChatMessageView(chatRoomListId: chatRoom.id, noticeBoardId: chatRoom.noticeBoardId, noticeBoardTitle: chatRoom.noticeBoardTitle, partnerId: chatRoom.partnerId, partnerImage: viewModel.getPartnerImageIndex(partnerId: chatRoom.partnerId, noticeBoardId: chatRoom.noticeBoardId), uid: chatRoom.userId)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0.0)
                    
                    VStack {
                        HStack(alignment: .top, spacing: 16) {
                            Image(uiImage: viewModel.getPartnerImageIndex(partnerId: chatRoom.partnerId, noticeBoardId: chatRoom.noticeBoardId))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(25)
                            
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Text(chatRoom.noticeBoardTitle)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(Color(.label))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Text(chatRoom.timeAgo)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(Color(.lightGray))
                                }
                                .padding(.top, 4)
                                .padding(.bottom, -2)
                                
                                HStack {
                                    Text(chatRoom.recentMessage)
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color(hex:"8A8A8E"))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail) // 뒤에는 ...으로 표시
                                    
                                    Spacer()
                                    
                                    if chatRoom.newCount != 0 {
                                        ZStack {
                                            Circle()
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(Color.red)
                                            
                                            Text("\(chatRoom.newCount)")
                                                .font(.system(size: 10, weight: .semibold))
                                                .foregroundStyle(Color.white)
                                            
                                        }
                                    }
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        Divider()
                    }
                    .padding(.top, 5)
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
