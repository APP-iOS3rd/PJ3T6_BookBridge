//
//  ChatListView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatRoomListView: View {
    @Binding var isShowPlusBtn: Bool
    
    @StateObject var viewModel = ChatRoomListViewModel()
    
    var isComeNoticeBoard: Bool
    var uid: String
    
    var body: some View {
        VStack {
            SearchChatListView(viewModel: viewModel)
                .padding()
            
            RoomListView(isShowPlusBtn: $isShowPlusBtn, viewModel: viewModel)
        }
        .onAppear {
            viewModel.checkUserLoginStatus(uid: uid)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if !isComeNoticeBoard {
                    isShowPlusBtn = true
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onDisappear {
            viewModel.firestoreListener?.remove()
        }
    }
}

