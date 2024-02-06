//
//  ChatListView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatListView: View {
    
    @State var showLogoutOptions = false
    @State var navigateToChatLogView = false

    @State var showNewMessageScreen = false
    @State var chatUser: ChatUser?
    
    @ObservedObject private var chatListVM = ChatListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                customNavBar
                messagesView
            }
            .navigationDestination(isPresented: $navigateToChatLogView) {
                ChatLogView(chatUser: self.chatUser)
                }
            .overlay(
                newMessageButton, alignment: .bottom)
            
            .toolbar(.hidden)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            // 프로필 이미지 가져오기
            WebImage(url: URL(string: chatListVM.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 44)
                        .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                let email = chatListVM.chatUser?.email ?? ""
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
                    .font(.system(size: 24, weight: .bold))
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
            })
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    NavigationLink {
                        Text("Destination")
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text("게시글 이름")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(.lightGray))
                            }
                            Spacer()
                            
                            Text("오전 9:41")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(.lightGray))
                        }
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 50)
        }
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
            })
        }
    }
}

#Preview {
    ChatListView()
//        .preferredColorScheme(.dark)
}
