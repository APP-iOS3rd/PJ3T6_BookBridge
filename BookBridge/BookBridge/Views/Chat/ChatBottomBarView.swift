//
//  ChatBottomBarView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct ChatBottomBarView: View {
    @StateObject var viewModel: ChatMessageViewModel
    
    @State var chatTextArr: [Substring] = []
    @State var isShowingPhoto = false
    @State var isShowingCamera = false
    
    @State private var keyboardHeight: CGFloat = 0
    
    @FocusState.Binding var isShowKeyboard: Bool
    
    @Binding var isPlusBtn: Bool
    
    var chatRoomListId: String
    var partnerId: String
    var uid: String
    
    var body: some View {
        VStack {
            HStack (spacing: 12) {
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
                        .padding(.leading, 6)
                        .padding(.trailing, 6)
                        .frame(minHeight: 40, maxHeight: 120)
                        .focused($isShowKeyboard)
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture {
                            isPlusBtn = true
                            isShowKeyboard = false
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
                    if !chatTextArr.isEmpty {
                        viewModel.handleSend(uid: uid, partnerId: partnerId, chatRoomListId: chatRoomListId)
                        
                        viewModel.sendNotification(partnerId: partnerId, message: viewModel.chatText)
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(chatTextArr.isEmpty ? Color.gray : Color(hex:"59AAE0"))
                }
                .disabled(chatTextArr.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            if !isPlusBtn {
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            isShowingPhoto = true
                        }) {
                            VStack {
                                Image(systemName: "photo.on.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color(.darkGray))
                            }
                        }
                        .padding()
                        .background(
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(hex: "D9D9D9"))
                                .opacity(0.4)
                        )
                        Text("사진")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            isShowingCamera = true
                        }) {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color(.darkGray))
                            
                        }
                        .padding()
                        .background(
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color.brown)
                                .opacity(0.6)
                        )
                        Text("카메라")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            // 위치 공유 버튼 기능 구현
                        }) {
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color(.darkGray))
                        }
                        .padding()
                        .background(
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color.yellow)
                                .opacity(0.6)
                        )
                        Text("위치공유")
                    }
                    
                    Spacer()
                    
                }
                .padding(.top, 80)
                .padding(.bottom, 80)
                .transition(.move(edge: .bottom))
            }
        }
        .fullScreenCover(isPresented: $isShowingPhoto, onDismiss: {
            withAnimation(.linear(duration: 0.2)) {
                isPlusBtn.toggle()
            }
            viewModel.handleSendImage(uid: uid, partnerId: partnerId, chatRoomListId: chatRoomListId)
        }) {
            ImagePicker(isVisible: $isShowingPhoto, images: $viewModel.selectedImages, sourceType: 1)
                .ignoresSafeArea(.all)
        }
        .fullScreenCover(isPresented: $isShowingCamera, onDismiss: {
            withAnimation(.linear(duration: 0.2)) {
                isPlusBtn.toggle()
            }
            viewModel.handleSendImage(uid: uid, partnerId: partnerId, chatRoomListId: chatRoomListId)
        }) {
            ImagePicker(isVisible: $isShowingCamera, images: $viewModel.selectedImages, sourceType: 0)
                .ignoresSafeArea(.all)
        }
    }
}
