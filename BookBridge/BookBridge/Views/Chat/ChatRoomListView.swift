//
//  ChatListView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatRoomListView: View {
    @StateObject var viewModel = ChatRoomListViewModel()
    
    @State var showNewMessageScreen = false
    
    var uid: String
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomNavBarView(viewModel: viewModel)
                
                RoomListView(viewModel: viewModel)
            }
        }
        .toolbar(.hidden)
        .onAppear {
            viewModel.checkUserLoginStatus(uid: uid)
        }
        .onDisappear {
            viewModel.firestoreListener?.remove()
        }
        /*
        .fullScreenCover(isPresented: $viewModel.isLogout) {
            //TODO: 우리 로그인 창 띄우기 LoginView에 @Binding var isLogout 필요
        }
         */
    }
    /*
    private var newMessageButton: some View {
        Button {
            showNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $showNewMessageScreen) {
           
        }
    }*/
}
