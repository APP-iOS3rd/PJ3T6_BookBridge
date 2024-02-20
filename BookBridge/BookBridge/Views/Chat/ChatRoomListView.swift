//
//  ChatListView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatRoomListView: View {
    @StateObject var viewModel = ChatRoomListViewModel()
    
    var uid: String
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchChatListView(viewModel: viewModel)
                    .padding()
//                CustomNavBarView(viewModel: viewModel)
                
                RoomListView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.checkUserLoginStatus(uid: uid)
                
            }
            .onDisappear {
                viewModel.firestoreListener?.remove()
            }
        }
        .toolbar(.hidden)
        /*
        .fullScreenCover(isPresented: $viewModel.isLogout) {
            //TODO: 우리 로그인 창 띄우기 LoginView에 @Binding var isLogout 필요
        }
         */
    }
}

#Preview {
    ChatRoomListView(uid: "lee")
}
