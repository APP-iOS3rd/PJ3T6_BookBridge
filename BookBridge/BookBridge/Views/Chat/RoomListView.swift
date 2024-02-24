//
//  RoomListView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct RoomListView: View {
    @Binding var isShowPlusBtn: Bool
    
    @StateObject var viewModel: ChatRoomListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.searchChatRoomList()) { chatRoom in
                ZStack {
                    NavigationLink {
                        ChatMessageView(
                            isShowPlusBtn: $isShowPlusBtn, isAlarm: chatRoom.isAlarm,
                            chatRoomListId: chatRoom.id,
                            chatRoomPartner: viewModel.getPartnerImageIndex(partnerId: chatRoom.partnerId, noticeBoardId: chatRoom.noticeBoardId).0 == -1 ? ChatPartnerModel(nickname: "닉네임 없음", noticeBoardId: chatRoom.noticeBoardId, partnerId: chatRoom.partnerId, partnerImage: UIImage(named: "DefaultImage")!, style: "칭호 미아") : viewModel.chatRoomPartners[viewModel.getPartnerImageIndex(partnerId: chatRoom.partnerId, noticeBoardId: chatRoom.noticeBoardId).0], noticeBoardTitle: chatRoom.noticeBoardTitle,
                            uid: chatRoom.userId)
                        .toolbar(.hidden, for: .tabBar)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0.0)

                    VStack {
                        HStack(spacing: 16) {
                            Image(uiImage: viewModel.getPartnerImageIndex(partnerId: chatRoom.partnerId, noticeBoardId: chatRoom.noticeBoardId).1)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(30)
                            
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Text(chatRoom.noticeBoardTitle)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(Color(.label))
                                        .multilineTextAlignment(.leading)
                                    
                                    if !chatRoom.isAlarm {
                                        Image(systemName: "bell.slash.fill")
                                            .font(.system(size: 16))
                                            .foregroundStyle(Color(hex:"8A8A8E"))
                                    }
                                    
                                    Spacer()
                                    
                                    Text(chatRoom.timeAgo)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(Color(.lightGray))
                                }
                                .padding(.top, 4)
                                .padding(.bottom, -2)
                                
                                HStack(alignment: .bottom) {
                                    Text(chatRoom.recentMessage)
                                        .font(.system(size: 15))
                                        .frame(height: 25)
                                        .foregroundStyle(Color(hex:"8A8A8E"))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail) // 뒤에는 ...으로 표시
                                        .padding(.top, 4)
                                    
                                    Spacer()
                                    
                                    if chatRoom.newCount != 0 {
                                        ZStack {
                                            Circle()
                                                .frame(width: 20, height: 20)
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
                    }
                    .padding(.top, 5)
                }
                .frame(height: 70)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}
