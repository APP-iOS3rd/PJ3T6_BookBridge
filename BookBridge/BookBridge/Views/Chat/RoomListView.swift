//
//  RoomListView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI
import Kingfisher

struct RoomListView: View {
    @EnvironmentObject private var pathModel: TabPathViewModel
    @StateObject var viewModel: ChatRoomListViewModel
    
    var body: some View {
        //TODO: 리스트 스크롤 바꾸니까 됨 나중에 ARABOZA
        ScrollView {
            ForEach(viewModel.searchChatRoomList()) { chatRoom in
                Button{
                    pathModel.paths.append(.chatMessage(isAlarm: chatRoom.isAlarm,
                                                        chatRoomListId: chatRoom.id,
                                                        chatRoomPartner: viewModel.chatRoomDic[chatRoom.id] ?? ChatPartnerModel(nickname: "닉네임 없음", noticeBoardId: chatRoom.noticeBoardId, partnerId: chatRoom.partnerId, partnerImage: UIImage(named: "DefaultImage")!, partnerImageUrl: "",reviews: [0, 0, 0], style: "칭호 미아"),
                                                        noticeBoardTitle: chatRoom.noticeBoardTitle,
                                                        uid: chatRoom.userId))
                }
            label: {
                VStack {
                    HStack(spacing: 16) {
                        KFImage(URL(string: viewModel.chatRoomDic[chatRoom.id]?.partnerImageUrl ?? ""))
                            .placeholder{
                                Image("DefaultImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(30)
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(30)
                        
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Text(viewModel.chatRoomDic[chatRoom.id]?.nickname ?? "")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color(.label))
                                    .multilineTextAlignment(.leading)
                                
                                Text(chatRoom.noticeBoardTitle)
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color(.lightGray))
                                    .truncationMode(.tail)
                                
                                if !chatRoom.isAlarm {
                                    Image(systemName: "bell.slash.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color(.lightGray))
                                }
                                
                                Spacer()
                                
                                Text(chatRoom.timeAgo)
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color(.lightGray))
                            }
                            .padding(.top, 4)
                            .padding(.bottom, -8)
                            
                            HStack(alignment: .bottom) {
                                Text(chatRoom.recentMessage)
                                    .font(.system(size: 15))
                                    .frame(height: 25)
                                    .foregroundStyle(Color(.lightGray))
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
                .background(.white)
                .padding(.top, 5)
                .frame(height: 70)
            }
                //                NavigationLink {
                //                    ChatMessageView(
                //                        isAlarm: chatRoom.isAlarm,
                //                        chatRoomListId: chatRoom.id,
                //                        chatRoomPartner: viewModel.chatRoomDic[chatRoom.id] ?? ChatPartnerModel(nickname: "닉네임 없음", noticeBoardId: chatRoom.noticeBoardId, partnerId: chatRoom.partnerId, partnerImage: UIImage(named: "DefaultImage")!, partnerImageUrl: "",reviews: [0, 0, 0], style: "칭호 미아"),
                //                        noticeBoardTitle: chatRoom.noticeBoardTitle,
                //                        uid: chatRoom.userId)
                //                } label: {
                //                    VStack {
                //                        HStack(spacing: 16) {
                //                            KFImage(URL(string: viewModel.chatRoomDic[chatRoom.id]?.partnerImageUrl ?? ""))
                //                                .placeholder{
                //                                    Image("DefaultImage")
                //                                        .resizable()
                //                                        .aspectRatio(contentMode: .fill)
                //                                        .frame(width: 60, height: 60)
                //                                        .cornerRadius(30)
                //                                }
                //                                .resizable()
                //                                .aspectRatio(contentMode: .fill)
                //                                .frame(width: 60, height: 60)
                //                                .cornerRadius(30)
                //
                //                            VStack(alignment: .leading) {
                //                                HStack(alignment: .center) {
                //                                    Text(viewModel.chatRoomDic[chatRoom.id]?.nickname ?? "")
                //                                        .font(.system(size: 18))
                //                                        .foregroundStyle(Color(.label))
                //                                        .multilineTextAlignment(.leading)
                //
                //                                    Text(chatRoom.noticeBoardTitle)
                //                                        .font(.system(size: 15))
                //                                        .foregroundStyle(Color(.lightGray))
                //
                //                                        .truncationMode(.tail)
                //
                //                                    if !chatRoom.isAlarm {
                //                                        Image(systemName: "bell.slash.fill")
                //                                            .font(.system(size: 16))
                //                                            .foregroundStyle(Color(.lightGray))
                //                                    }
                //
                //                                    Spacer()
                //
                //                                    Text(chatRoom.timeAgo)
                //                                        .font(.system(size: 15))
                //                                        .foregroundStyle(Color(.lightGray))
                //                                }
                //                                .padding(.top, 4)
                //                                .padding(.bottom, -8)
                //
                //                                HStack(alignment: .bottom) {
                //                                    Text(chatRoom.recentMessage)
                //                                        .font(.system(size: 15))
                //                                        .frame(height: 25)
                //                                        .foregroundStyle(Color(.lightGray))
                //                                        .multilineTextAlignment(.leading)
                //                                        .lineLimit(1)
                //                                        .truncationMode(.tail) // 뒤에는 ...으로 표시
                //                                        .padding(.top, 4)
                //
                //                                    Spacer()
                //
                //                                    if chatRoom.newCount != 0 {
                //                                        ZStack {
                //                                            Circle()
                //                                                .frame(width: 20, height: 20)
                //                                                .foregroundColor(Color.red)
                //
                //                                            Text("\(chatRoom.newCount)")
                //                                                .font(.system(size: 10, weight: .semibold))
                //                                                .foregroundStyle(Color.white)
                //                                        }
                //                                    }
                //                                }
                //                                .padding(.bottom, 10)
                //                            }
                //                        }
                //                    }
                //                    .background(.white)
                //                    .padding(.top, 5)
                //                    .frame(height: 70)
                //                }
            }
            .padding(.horizontal)

        }
    }
}
