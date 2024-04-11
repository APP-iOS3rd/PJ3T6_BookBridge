//
//  ChatBottomBarView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct ChatBottomBarView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("isAlarmEnabled") private var isChattingAlarm: Bool = true
    
    @Binding var isPlusBtn: Bool
    
    @StateObject var viewModel: ChatMessageViewModel
    
    @State var chatTextArr: [Substring] = []
    @State private var isShowingCamera = false
    @State private var isShowingLocation = false
    @State private var isShowingPhoto = false
    @State private var keyboardHeight: CGFloat = 0
    
    @FocusState.Binding var isShowKeyboard: Bool
    
    var chatRoomListId: String
    var partnerId: String
    var uid: String
    
    @State var zero: Int = 0
    @State var one: Int = 1
    
    var body: some View {
        VStack {
            HStack (spacing: 5) {
                
                Button {
                    withAnimation(.linear(duration: 0.2)) {
                        isPlusBtn.toggle()
                    }
                    isShowKeyboard = false
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 23, height: 23)
                        .rotationEffect(.degrees(isPlusBtn ? 0 : 45))
                        .foregroundStyle(Color(.darkGray))
                        .padding(5)
                }
                
                ZStack {
                    HStack {
                        Text("내용을 입력해주세요")
                            .foregroundColor(Color(.gray))
                            .font(.system(size: 17))
                            .padding(.leading, 12)
                        Spacer()
                    }
                    
                    TextEditor(text: $viewModel.chatText)
                        .opacity(viewModel.chatText.isEmpty ? 0.5 : 1)
                        .padding(.top, 3)
                        .padding(.horizontal, 6)
                        .frame(minHeight: 40, maxHeight: 120)
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture {
                            isPlusBtn = true
                            //                            isShowKeyboard = false
                        }
                        .onChange(of: viewModel.chatText) { _ in
                            withAnimation {
                                chatTextArr = viewModel.chatText.split{ $0 == " " || $0 == "\n"}
                            }
                        }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.gray, lineWidth: 1)
                )
                
                
                Button {
                    Task{
                        //수신자가 발신자를 차단한 상태인지 확인
                        await UserManager.shared.fetchPartnerBlockedUsers(partnerId: partnerId)
                        viewModel.isBlocked = UserManager.shared.partnerBlockedUsers.contains(uid)
                        
                        //위에 비동기 작업이 완료된 후 실행
                        await MainActor.run {
                            if !chatTextArr.isEmpty {
                                if viewModel.saveChatRoomId == "" {
                                    viewModel.handleSendNoId(uid: uid, partnerId: partnerId) {
                                        viewModel.handleSend(uid: uid, partnerId: partnerId)
                                        viewModel.fetchMessages(uid: uid)
                                    }
                                } else {
                                    if viewModel.chatMessages.isEmpty {
                                        viewModel.handleNoChatRoom(uid: uid, partnerId: partnerId, chatRoomListId: chatRoomListId) {
                                            viewModel.handleSend(uid: uid, partnerId: partnerId)
                                        }
                                    } else {
                                        viewModel.handleSend(uid: uid, partnerId: partnerId)
                                    }
                                }
                            }
                        }
                        
                    }
                    
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(chatTextArr.isEmpty ? Color.gray : Color(hex:"59AAE0"))
                        .padding(5)
                }
                .disabled(chatTextArr.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            if !isPlusBtn {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color(.darkGray))
                            .background(
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color(hex: "D9D9D9"))
                                    .opacity(0.4)
                            )
                            .padding()
                        Text("사진")
                    }
                    .onTapGesture {
                        isShowingPhoto = true
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color(.darkGray))
                            .background(
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color.brown)
                                    .opacity(0.6)
                            )
                            .padding()
                        
                        Text("카메라")
                    }
                    .onTapGesture {
                        isShowingCamera = true
                    }
                    
                    Spacer()
                    
                    VStack {
                        
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color(.darkGray))
                            .padding()
                            .background(
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color.yellow)
                                    .opacity(0.6)
                            )
                        
                        Text("위치공유")
                    }
                    .onTapGesture {
                        isShowingLocation.toggle()
                    }
                    
                    Spacer()
                    
                }
                .padding(.top, 80)
                .padding(.bottom, 80)
                .transition(.move(edge: .bottom))
            }
        }
        .focused($isShowKeyboard)
        .fullScreenCover(isPresented: $isShowingPhoto, onDismiss: {
            withAnimation(.linear(duration: 0.2)) {
                isPlusBtn.toggle()
            }
            
            Task{
                //수신자가 발신자를 차단한 상태인지 확인
                await UserManager.shared.fetchPartnerBlockedUsers(partnerId: partnerId)
                //수신자가 발신자를 차단한 상태인지 확인
                viewModel.isBlocked = UserManager.shared.partnerBlockedUsers.contains(uid)
                //위에 비동기 작업이 완료된 후 실행
                await MainActor.run {
                    if viewModel.saveChatRoomId != "" {
                        if viewModel.chatMessages.isEmpty {
                            viewModel.handleNoChatRoom(uid: uid, partnerId: partnerId, chatRoomListId: chatRoomListId) {
                                viewModel.handleSendImage(uid: uid, partnerId: partnerId)
                            }
                        } else {
                            viewModel.handleSendImage(uid: uid, partnerId: partnerId)
                        }
                    } else {
                        viewModel.handleSendNoId(uid: uid, partnerId: partnerId, completion: {
                            viewModel.handleSendImage(uid: uid, partnerId: partnerId)
                            viewModel.fetchMessages(uid: uid)
                        })
                    }
                }
            }
            
        }) {
            ImagePicker(isVisible: $isShowingPhoto, images: $viewModel.selectedImages, sourceType: $one)
                .ignoresSafeArea(.all)
        }
        .fullScreenCover(isPresented: $isShowingCamera, onDismiss: {
            withAnimation(.linear(duration: 0.2)) {
                isPlusBtn.toggle()
            }
            
            Task{
                //수신자가 발신자를 차단한 상태인지 확인
                await UserManager.shared.fetchPartnerBlockedUsers(partnerId: partnerId)
                //수신자가 발신자를 차단한 상태인지 확인
                viewModel.isBlocked = UserManager.shared.partnerBlockedUsers.contains(uid)
                //위에 비동기 작업이 완료된 후 실행
                await MainActor.run {
                    if viewModel.saveChatRoomId != "" {
                        if viewModel.chatMessages.isEmpty {
                            viewModel.handleNoChatRoom(uid: uid, partnerId: partnerId, chatRoomListId: chatRoomListId) {
                                viewModel.handleSendImage(uid: uid, partnerId: partnerId)
                            }
                        } else {
                            viewModel.handleSendImage(uid: uid, partnerId: partnerId)
                        }
                    } else {
                        viewModel.handleSendNoId(uid: uid, partnerId: partnerId, completion: {
                            viewModel.handleSendImage(uid: uid, partnerId: partnerId)
                            viewModel.fetchMessages(uid: uid)
                        })
                    }
                }
            }
        }) {
            ImagePicker(isVisible: $isShowingCamera, images: $viewModel.selectedImages, sourceType: $zero)
                .ignoresSafeArea(.all)
        }
        .fullScreenCover(isPresented: $isShowingLocation, onDismiss: {
            withAnimation(.linear(duration: 0.2)) {
                isPlusBtn.toggle()
            }
        }) {
            ChatExchangeHopeView(viewModel: viewModel, chatRoomListId: chatRoomListId, partnerId: partnerId, uid: uid)
        }
        
    }
}

