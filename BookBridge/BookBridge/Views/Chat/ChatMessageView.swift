//
//  ChatMessageView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatMessageView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = ChatMessageViewModel()
    
    @State private var isPlusBtn = true

    @FocusState var isShowKeyboard: Bool
    
    @State var isAlarm: Bool = true
    
    var chatRoomListId: String
    var noticeBoardTitle: String
    var chatRoomPartner: ChatPartnerModel
    var uid: String
    
    var body: some View {
        VStack {
            NoticeBoardChatView(viewModel: viewModel, chatRoomListId: chatRoomListId, uid: uid)
            
            MessageListView(viewModel: viewModel, partnerId: chatRoomPartner.partnerId, partnerImage: chatRoomPartner.partnerImage, uid: uid)
            
            ChatBottomBarView(viewModel: viewModel, isShowKeyboard: $isShowKeyboard, isPlusBtn: $isPlusBtn, chatRoomListId: chatRoomListId, partnerId: chatRoomPartner.partnerId, uid: uid)
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
                isPlusBtn = true
            }
            isShowKeyboard = false
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
                Menu {
                    Button {
                        
                    } label: {
                        Text("신고하기")
                    }
                    
                    Button {
                        viewModel.changeAlarm(uid: uid, chatRoomListId: chatRoomListId, isAlarm: isAlarm)
                        isAlarm.toggle()
                    } label: {
                        if isAlarm {
                            Text("알림끄기")
                        } else {
                            Text("알림켜기")
                        }
                    }
                
                    Button(role: .destructive) {
                        
                    } label: {
                        Label("채팅방나가기", systemImage: "trash")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            viewModel.initNewCount(uid: uid, chatRoomId: chatRoomListId)
            viewModel.fetchMessages(uid: uid, chatRoomListId: chatRoomListId)
            viewModel.getNoticeBoardInfo(noticeBoardId: chatRoomPartner.noticeBoardId)
        }
    }
}
