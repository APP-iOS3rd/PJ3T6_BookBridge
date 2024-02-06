//
//  ChatListView.swift
//  BookBridge
//
//  Created by jmyeong on 2/6/24.
//

import SwiftUI

struct ChatListView: View {
    
    @State var showLogoutOptions = false
    
    @ObservedObject private var chatListVM = ChatListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("CURRENT USER ID: \(chatListVM.errorMessage)")
                
                customNavBar
                messagesView
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            
            .toolbar(.hidden)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.fill")
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("USERNAME")
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
            .init(
                title: Text("Settings"),
                message: Text("What do you want to do?"),
                buttons: [.destructive(Text("Sign Out"), action: { print("handle sign out")}),
                          .cancel()
                ])
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(.lightGray))
                        }
                        Spacer()
                        
                        Text("오전 9:41")
                            .font(.system(size: 14, weight: .semibold))
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
    }
}

#Preview {
    ChatListView()
//        .preferredColorScheme(.dark)
}
