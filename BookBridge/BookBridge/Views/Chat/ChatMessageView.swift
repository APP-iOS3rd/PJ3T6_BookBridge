//
//  ChatMessageView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatMessageView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var pathModel: TabPathViewModel
    
    @StateObject var viewModel = ChatMessageViewModel()
    
    @State var isAlarm: Bool = true
    @State private var isAlert = false
    @State private var isPlusBtn = true
    @State private var isPresented = false
    
    @FocusState var isShowKeyboard: Bool
    
    var chatRoomListId: String
    var chatRoomPartner: ChatPartnerModel
    var noticeBoardTitle: String
    var uid: String
    
    var body: some View {
        ZStack {
            ClearBackground(
                isFocused: $isShowKeyboard
            )
            VStack {
                if viewModel.noticeBoardInfo.userId == "" && viewModel.noticeBoardInfo.noticeBoardTitle == "" {
                    ZStack {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .foregroundStyle(Color(.lightGray))
                        
                        Text("게시물이 삭제되서 이전 채팅만 볼 수 있어요...")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                    }
                } else {
                    NoticeBoardChatView( viewModel: viewModel, chatRoomPartner: chatRoomPartner, chatRoomListId: viewModel.saveChatRoomId, noticeBoardId: chatRoomPartner.noticeBoardId, partnerId: chatRoomPartner.partnerId, uid: uid)
                }
                
                MessageListView( viewModel: viewModel, chatRoomPartner: chatRoomPartner, uid: uid)
                
                if !(viewModel.noticeBoardInfo.userId == "" && viewModel.noticeBoardInfo.noticeBoardTitle == "") {
                    if viewModel.noticeBoardInfo.state == 0 {
                        //게시물 상태가 0
                        ChatBottomBarView(isPlusBtn: $isPlusBtn, viewModel: viewModel, isShowKeyboard: $isShowKeyboard, chatRoomListId: viewModel.saveChatRoomId, partnerId: chatRoomPartner.partnerId, uid: uid)
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
                                    Text("\"\(viewModel.reservationName)\"님과 교환을 완료했습니다.")
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .font(.system(size: 18))
                                        .foregroundStyle(.white)
                                        .bold()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                                .background(Color(.lightGray))
                            }
                        } else if viewModel.noticeBoardInfo.reservationId == uid || viewModel.noticeBoardInfo.userId == uid {
                            //게시물 작성자 == 나 이거나 예약자 == 대화하고있는 사람
                            ChatBottomBarView(isPlusBtn: $isPlusBtn, viewModel: viewModel, isShowKeyboard: $isShowKeyboard, chatRoomListId: viewModel.saveChatRoomId, partnerId: chatRoomPartner.partnerId, uid: uid)
                        } else {
                            if viewModel.noticeBoardInfo.state == 1 {
                                Text("현재 다른 사람과 예약중입니다.")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .foregroundStyle(.white)
                                    .background(Color(.lightGray))
                            } else {
                                Text("다른 사람과 교환이 완료되었습니다.")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .foregroundStyle(.white)
                                    .background(Color(.lightGray))
                            }
                        }
                    }
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    VStack {
                        if isPresented {
                            Button {
                                viewModel.changeAlarm(uid: uid, isAlarm: isAlarm)
                                isAlarm.toggle()
                            } label: {
                                if isAlarm {
                                    Text("알림끄기")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(.black)
                                        .padding(1)
                                } else {
                                    Text("알림켜기")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(.black)
                                        .padding(1)
                                }
                            }
                            
                            Divider()
                            
//                            NavigationLink {
//                                ReportView(reportVM: reportVM)
//                            } 
                            Button {
                                pathModel.paths.append(.report(ischat: true, targetId: viewModel.saveChatRoomId))
                            } label: {
                                Text("신고하기")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.black)
                                    .padding(1)
                            }
                            
                            Divider()
                            
                            Button {
                                isAlert.toggle()
                            } label: {
                                Text("채팅방나가기")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.red)
                                    .padding(1)
                            }
                            .alert("채팅방을 나가시겠습니까?", isPresented: $isAlert, actions: {
                                Button("나가기", role: .destructive) {
                                    viewModel.deleteChatRoom(uid: uid, partnerId: chatRoomPartner.partnerId) {
                                        dismiss()
                                    }
                                }
                                Button("취소", role: .cancel) {
                                    isAlert.toggle()
                                }
                            }, message: {
                                Text("나가기를 하면 대화내용이 모두 삭제되고 채팅목록에서도 삭제됩니다")
                                    .font(.system(size: 10))
                            })
                        }
                    }
                    .frame(width: 120, height: isPresented ? 110 : 0)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .foregroundColor(Color(uiColor: .systemGray6))
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
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
                HStack {
                    Text(chatRoomPartner.style == "" ? "칭호없음" : chatRoomPartner.style)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "4B4B4C"))
                        .background(Color(hex: "D9D9D9"))
                        .cornerRadius(5)
                        .minimumScaleFactor(0.7)
                    
                    Text(chatRoomPartner.nickname)
                        .font(.system(size: 15, weight: .bold))
                }
            }
            
            if !viewModel.chatMessages.isEmpty {
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
        }
        .onAppear {
            if chatRoomListId != "" {
                viewModel.saveChatRoomId = chatRoomListId
                viewModel.initNewCount(uid: uid)
                viewModel.fetchMessages(uid: uid)
            } else {
                viewModel.saveChatRoomId = ""
            }
            viewModel.getNoticeBoardInfo(noticeBoardId: chatRoomPartner.noticeBoardId)
        
        }
        .onDisappear {
            if viewModel.saveChatRoomId != "" {
                viewModel.initNewCount(uid: uid)
            }
        }
    }
}
