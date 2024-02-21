//
//  noticeBoardChatView.swift
//  BookBridge
//
//  Created by 이현호 on 2/14/24.
//

import SwiftUI

struct NoticeBoardChatView: View {
    @Binding var isShowPlusBtn: Bool
    
    @StateObject var viewModel: ChatMessageViewModel
    
    var chatRoomListId: String
    var uid: String
    
    var body: some View {
        HStack {
            NavigationLink {
                PostView(isShowPlusBtn: $isShowPlusBtn, noticeBoard: viewModel.noticeBoardInfo)
            } label: {
                HStack {
                    Image(uiImage: viewModel.bookImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 41)
                    .foregroundStyle(.black)
                    .padding(.trailing, 4)
                    
                    VStack(alignment:.leading) {
                        Text(viewModel.noticeBoardInfo.noticeBoardTitle)
                            .padding(.bottom, 1)
                            .font(.system(size: 17, weight: .bold))
                            .lineLimit(1)
                            .foregroundStyle(.black)
                        Text(viewModel.noticeBoardInfo.noticeLocationName)
                            .font(.system(size: 14))
                            .lineLimit(1)
                            .foregroundStyle(.gray)
                    }
                    .padding(.trailing)
                }
            }
            
            Spacer()
            
            Button(action: {
                let newState = viewModel.noticeBoardInfo.state == 1 ? 0 : 1
                
                viewModel.changeState(uid: uid, chatRoomListId: chatRoomListId, state: newState)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(viewModel.noticeBoardInfo.state == 1 ? Color.blue : Color(.lightGray))
                        .frame(width: 60, height: 30)
                    Text("예약중")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
            
            Button(action: {
                let newState = viewModel.noticeBoardInfo.state == 2 ? 0 : 2
                
                viewModel.changeState(uid: uid, chatRoomListId: chatRoomListId, state: newState)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(viewModel.noticeBoardInfo.state == 2 ? Color.green : Color(.lightGray))
                        .frame(width: 60, height: 30)
                    Text("교환완료")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal)
        
        Divider()
    }
}

