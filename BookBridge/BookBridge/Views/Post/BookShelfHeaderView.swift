//
//  BookShelfHeaderView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

struct BookshelfHeaderView: View {
    @StateObject var postViewModel: PostViewModel
    var bookTypeName: String
                    
    var body: some View {
            HStack {
                Text(bookTypeName)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink(
                    destination: BookShelfView(userId: postViewModel.user.id, initialTapInfo: .hold, isBack: true)
                        .navigationBarTitle( postViewModel.user.id == UserManager.shared.uid ? "내책장" : "\(postViewModel.user.nickname ?? "")님의 책장", displayMode: .inline)
                        .navigationBarItems(leading: CustomBackButtonView())
                        .navigationBarBackButtonHidden(true)
                ) {
                    Text("더보기")
                        .foregroundStyle(Color(red: 153/255, green: 153/255, blue: 153/255))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
        }
}

