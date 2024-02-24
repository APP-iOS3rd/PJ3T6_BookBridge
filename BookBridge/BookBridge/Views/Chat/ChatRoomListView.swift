//
//  ChatListView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatRoomListView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var isShowPlusBtn: Bool
    
    @StateObject var viewModel = ChatRoomListViewModel()
    
    var chatRoomList: [String]
    var isComeNoticeBoard: Bool
    var uid: String
    
    var body: some View {
        VStack {
            SearchChatListView(viewModel: viewModel)
                .padding()
                .onTapGesture {
                    isShowPlusBtn = false
                }
            
            if viewModel.searchChatRoomList().isEmpty {
                Spacer()
                
                VStack {
                    Image(uiImage: UIImage(named: "Character")!)
                        .resizable()
                        .frame(width: 150, height: 180)
                    
                    Text("아직 채팅방이 없어요....")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Color(hex: "767676"))
                }
                
                Spacer()
                Spacer()
            } else {
                RoomListView(isShowPlusBtn: $isShowPlusBtn, viewModel: viewModel)
            }
        }
        .navigationBarBackButtonHidden()
        .onTapGesture {
            hideKeyboard()
            isShowPlusBtn = true
        }
        .onAppear {            
            if !(isComeNoticeBoard && chatRoomList.isEmpty) {
                viewModel.checkUserLoginStatus(uid: uid, isComeNoticeBoard: isComeNoticeBoard, chatRoomListStr: chatRoomList)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if !isComeNoticeBoard {
                    isShowPlusBtn = true
                }
            }
        }
        .onDisappear {
            viewModel.firestoreListener?.remove()
        }
        .toolbar {
            if isComeNoticeBoard {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}

