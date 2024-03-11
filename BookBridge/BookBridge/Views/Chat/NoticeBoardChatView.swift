//
//  noticeBoardChatView.swift
//  BookBridge
//
//  Created by 이현호 on 2/14/24.
//

import SwiftUI

struct NoticeBoardChatView: View {
    @EnvironmentObject private var pathModel: TabPathViewModel
    @StateObject var viewModel: ChatMessageViewModel
    
    var chatRoomListId: String
    var noticeBoardId: String
    var partnerId: String
    var uid: String
    
    var body: some View {
        HStack {
            
            Button {
                pathModel.paths.append(.postview(noticeboard: viewModel.noticeBoardInfo))
            } label: {
                HStack {
                    Image(uiImage: viewModel.bookImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 60)
                        .foregroundStyle(.black)
                        .cornerRadius(5)
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
                .padding(.bottom, 5)
            }
            .onDisappear {
                viewModel.firestoreListener?.remove()
            }
            
            Spacer()
            
            if viewModel.noticeBoardInfo.userId != uid {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(
                            viewModel.noticeBoardInfo.state == 0 ? Color.white : (viewModel.noticeBoardInfo.state == 1 ? Color.blue : Color.green)
                        )
                        .frame(width: 60, height: 30)
                    Text(
                        viewModel.noticeBoardInfo.state == 0 ? "" : (viewModel.noticeBoardInfo.state == 1 ? "예약중" : "교환완료")
                    )
                    .font(.caption)
                    .foregroundStyle(.white)
                }
            } else {
                Button(action: {
                    let newState = viewModel.noticeBoardInfo.state == 1 ? 0 : 1
                    
                    viewModel.changeState(state: newState, partnerId: partnerId, noticeBoardId: noticeBoardId)
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
                    
                    viewModel.changeState(state: newState, partnerId: partnerId, noticeBoardId: noticeBoardId)
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
        }
        .padding(.top, 8)
        .padding(.horizontal)
        .onAppear {
            print(uid, viewModel.noticeBoardInfo.userId)
        }
        
        Divider()
        
        if viewModel.noticeBoardInfo.reservationId == partnerId {
            ZStack {
                Rectangle()
                    .foregroundStyle(.orange)
                    .opacity(0.8)
                    .frame(maxWidth: .infinity, maxHeight: 30)
                Text("현재 상대방과 예약 진행중입니다")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .bold()
            }
            .padding(-8)
        }
    }
}
