//
//  TabBarView.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            // 홈
            EmptyView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            // 채팅
            EmptyView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            
            // 게시글 작성
            ChangePostingView() // 플러스 버튼은 빈 뷰로 처리합니다.
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40)) // 플러스 버튼은 크게 표시합니다.
                }
            
            // 책장
            EmptyView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Bookshelf")
                }
            
            //마이페이지
            EmptyView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("My Page")
                }
        }
    }
}

#Preview {
    TabBarView()
}
