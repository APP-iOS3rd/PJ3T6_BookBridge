//
//  ChatListView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI

struct ChatListView: View {
    
    @State var showLogoutOptions = false
    @State var navigateToChatLogView = false
    
    @State var showNewMessageScreen = false
    @State var chatUser: ChatUser?
    
    @ObservedObject private var chatListVM = ChatListViewModel()
    
    private var chatLogViewModel = ChatLogViewModel(chatUser: nil)
    
    var body: some View {
        NavigationStack {
            VStack {
                customNavBar
                messagesView
            }
            .navigationDestination(isPresented: $navigateToChatLogView) {
                ChatLogView(chatLogVM: chatLogViewModel)
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            
            .toolbar(.hidden)
        }
        //        .onAppear {
        //            // 채팅 목록 화면이 나타날 때 새로운 메시지를 감시
        //            chatListVM.listenForNewMessages()
        //        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            // 프로필 이미지 가져오기
            AsyncImage(url: URL(string: chatListVM.chatUser?.profileImageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black, lineWidth: 1)
                            .shadow(radius: 5)
                    )
            } placeholder: {
                // Placeholder 이미지 (로딩 중 표시될 이미지)
                ProgressView()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                let email = chatListVM.chatUser?.uid ?? ""
                Text("\(email)")
                    .font(.system(size: 24, weight: .bold))
                HStack {
                    Circle()
                        .foregroundStyle(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(.lightGray))
                }
            }
            Spacer()
            Button {
                showLogoutOptions.toggle()
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $showLogoutOptions) {
            ActionSheet(
                title: Text("알림"),
                message: Text("로그아웃 하시겠습니까?"),
                buttons: [
                    .destructive(Text("로그아웃"), action: {
                        print("handle sign out")
                        chatListVM.handleSignOut()
                    }),
                    .cancel()
                ]
            )
        }
        .fullScreenCover(isPresented: $chatListVM.isUserCurrentlyLoggedOut, onDismiss: nil) {
            ChatLoginView(didCompleteLoginProcess: {
                self.chatListVM.isUserCurrentlyLoggedOut = false
                self.chatListVM.fetchCurrentUser()
                self.chatListVM.fetchRecentMessages()
            })
        }
    }
    
    private var messagesView: some View {
        List {
            ForEach(chatListVM.recentMessages) { recentMessage in
                VStack {
                    Button {
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                        self.chatUser = .init(data: [
                            FirebaseConstants.email: recentMessage.email,
                            FirebaseConstants.profileImageUrl: recentMessage.profileImageUrl,
                            FirebaseConstants.uid: uid
                        ])
                        self.chatLogViewModel.chatUser = self.chatUser
                        self.chatLogViewModel.fetchMessages()
                        self.navigateToChatLogView.toggle()
                    } label: {
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: recentMessage.profileImageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipped()
                                    .cornerRadius(64)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 64)
                                            .stroke(Color(.label), lineWidth: 1)
                                    )
                            } placeholder: {
                                // Placeholder 이미지 설정
                                ProgressView()
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.email)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color(.label))
                                    .multilineTextAlignment(.leading)
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(hex:"8A8A8E"))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2) // 두 줄까지만 표시
                                    .truncationMode(.tail) // 뒤에는 ...으로 표시
                            }
                            Spacer()
                            
                            Text(recentMessage.timeAgo)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(.lightGray))
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let chatUserID = chatUser?.uid {
                                chatListVM.deleteChatList(chatUserID: chatUserID)
                            }
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                    Divider()
                }
            }
            
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
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
            CreateNewMessageView(didSelectNewUser: { user in
                print(user.email)
                self.navigateToChatLogView.toggle()
                self.chatUser = user
                self.chatLogViewModel.chatUser = user
                self.chatLogViewModel.fetchMessages()
            })
        }
    }
}

#Preview {
    ChatListView()
    //        .preferredColorScheme(.dark)
}
