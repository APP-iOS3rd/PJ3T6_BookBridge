//
//  BookShelfHeaderView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

struct BookshelfHeaderView: View {
    @StateObject var postViewModel: PostViewModel
    @Binding var isShowPlusBtn : Bool
    var bookTypeName: String
    
    var body: some View {
        HStack {
            Text(bookTypeName)
                .font(.system(size: 18, weight: .bold))
            
            Spacer()
            
            NavigationLink {
                BookShelfView(userId: postViewModel.user.id, initialTapInfo: .hold, isBack: true, isShowPlusBtn: $isShowPlusBtn)
                    .navigationBarTitle( postViewModel.user.id == UserManager.shared.uid ? "내책장" : "\(postViewModel.user.nickname ?? "")님의 책장", displayMode: .inline)
                    .navigationBarItems(leading: CustomBackButtonView())
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text("더보기")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: "767676"))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

