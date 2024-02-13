//
//  CreateNewMessageView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateNewMessageView: View {

    let didSelectNewUser: (ChatUser) -> ()
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var createNewMessageVM = CreateNewMessageViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(createNewMessageVM.errorMessage)
                
                ForEach(createNewMessageVM.users) { user in
                    Button {
                        dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.label), lineWidth: 1)
                                )
                            Text(user.email)
                                .foregroundStyle(Color(.label))
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

#Preview {
//    CreateNewMessageView()
    ChatListView()
}
