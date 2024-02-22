//
//  ChatMessageView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatMessageView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var isShowPlusBtn: Bool
    
    @StateObject var viewModel = ChatMessageViewModel()
    
    @State var isAlarm: Bool = true
    
    @State private var isPlusBtn = true
    @State private var isPresented = false
    
    @FocusState var isShowKeyboard: Bool
    
    var chatRoomListId: String
    var noticeBoardTitle: String
    var chatRoomPartner: ChatPartnerModel
    var uid: String
    
    var body: some View {
        ZStack {
            VStack {
                NoticeBoardChatView(isShowPlusBtn: $isShowPlusBtn, viewModel: viewModel, chatRoomListId: chatRoomListId, noticeBoardId: chatRoomPartner.noticeBoardId, partnerId: chatRoomPartner.partnerId, uid: uid)
                
                MessageListView(viewModel: viewModel, partnerId: chatRoomPartner.partnerId, partnerImage: chatRoomPartner.partnerImage, uid: uid)
                
                if viewModel.noticeBoardInfo.state == 0 {
                    //게시물 상태가 0
                    ChatBottomBarView(viewModel: viewModel, isShowKeyboard: $isShowKeyboard, isPlusBtn: $isPlusBtn, chatRoomListId: chatRoomListId, partnerId: chatRoomPartner.partnerId, uid: uid)
                } else {
                    if viewModel.noticeBoardInfo.reservationId != chatRoomPartner.partnerId && viewModel.noticeBoardInfo.userId == uid {
                        //게시물 작성자 == 나 이면서 예약자는 대화하고있는 사람이 아닌
                        if viewModel.noticeBoardInfo.state == 1 {
                            VStack(spacing: 10) {
                                Text("현재 \"\(viewModel.reservationName)\"님과 예약 진행중입니다.\n예약자를 변경하시겠습니까?")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .font(.system(size: 18).bold())
                                    .foregroundStyle(.white)
                                
                                Button(action: {
                                    viewModel.changeState(state: 1, partnerId: chatRoomPartner.partnerId, noticeBoardId: chatRoomPartner.noticeBoardId)
                                }) {
                                    Text("확인")
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .font(.system(size: 18, weight: .bold))
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(.white)
                                        .background(Color(hex:"59AAE0"))
                                        .cornerRadius(10)
                                        .padding(.horizontal, 60)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .background(Color(.lightGray))
                        } else {
                            VStack(spacing: 10) {
                                Text("\"\(viewModel.reservationName)\"님과 교환 완료했습니다.")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .font(.system(size: 18))
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(Color(.lightGray))
                        }
                    } else if viewModel.noticeBoardInfo.reservationId == uid || viewModel.noticeBoardInfo.userId == uid {
                        //게시물 작성자 == 나 이거나 예약자 == 대화하고있는 사람
                        ChatBottomBarView(viewModel: viewModel, isShowKeyboard: $isShowKeyboard, isPlusBtn: $isPlusBtn, chatRoomListId: chatRoomListId, partnerId: chatRoomPartner.partnerId, uid: uid)
                    } else {
                        if viewModel.noticeBoardInfo.state == 1 {
                            Text("현재 다른 사람과 예약중입니다.")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .font(.system(size: 18).bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .foregroundStyle(.white)
                                .background(Color(.lightGray))
                        } else {
                            Text("다른 사람과 교환이 완료되었습니다.")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .font(.system(size: 18).bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .foregroundStyle(.white)
                                .background(Color(.lightGray))
                        }
                    }
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        if isPresented {
                            NavigationLink {
                                ReportChatView(reportVM: ReportViewModel(), nickname: chatRoomPartner.nickname)
                            } label: {
                                Text("신고하기")
                                    .font(.system(size: 14))
                                    .padding(1)
                            }
                            
                            Divider()
                            
                            Button {
                                viewModel.changeAlarm(uid: uid, chatRoomListId: chatRoomListId, isAlarm: isAlarm)
                                isAlarm.toggle()
                            } label: {
                                if isAlarm {
                                    Text("알림끄기")
                                        .font(.system(size: 14))
                                        .padding(1)
                                } else {
                                    Text("알림켜기")
                                        .font(.system(size: 14))
                                        .padding(1)
                                }
                            }
                            
                            Divider()
                            
                            Button(role: .destructive) {
                                
                            } label: {
                                Label("채팅방나가기", systemImage: "trash")
                                    .font(.system(size: 14))
                                    .padding(1)
                            }
                        }
                    }
                    .frame(width: 120, height: isPresented ? 110 : 0)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .foregroundColor(Color(red: 230/255, green: 230/255, blue: 230/255))
                    )
                    .padding(.trailing)
                }
                Spacer()
            }
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
                isPlusBtn = true
                isShowKeyboard = false
                isPresented = false
            }
        }
        .transition(.move(edge: .bottom))
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
                        Text(chatRoomPartner.style)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    Text(chatRoomPartner.nickname)
                        .font(.headline)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isPresented.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            isShowPlusBtn = false
            viewModel.initNewCount(uid: uid, chatRoomId: chatRoomListId)
            viewModel.fetchMessages(uid: uid, chatRoomListId: chatRoomListId)
            viewModel.getNoticeBoardInfo(noticeBoardId: chatRoomPartner.noticeBoardId)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}
