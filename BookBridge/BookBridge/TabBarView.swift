//
//  TabBarView.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import SwiftUI

struct TabBarView: View {
    let userId : String?
    
    
    @State private var isLogin = UserManager.shared.isLogin
    @State private var showingLoginAlert = false
    @State private var showingLoginView = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                // 홈
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                // 채팅
                EmptyView()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chat")
                    }
                    .tag(1)
                
                
                // 게시글 작성
                NavigationStack{
                    ChangePostingView()
                }// 플러스 버튼은 빈 뷰로 처리합니다.
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40)) // 플러스 버튼은 크게 표시합니다.
                }
                .tag(2)
                
                // 책장
                NavigationStack{
                    if isLogin {
                        BookShelfView(userId : UserManager.shared.uid,initialTapInfo: .wish)
                    }
                    else {
                        BookShelfView(userId: nil,initialTapInfo: .wish)
                            .onAppear {
                                showingLoginAlert = true
                            }
                    }
                }
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("내 책장")
                }
                .tag(3)
                .alert(isPresented: $showingLoginAlert) {
                    Alert(
                        title: Text("로그인 필요"),
                        message: Text("이 기능을 사용하려면 로그인이 필요합니다."),
                        primaryButton: .default(Text("로그인"), action: {
                            showingLoginView = true
                        }),
                        secondaryButton: .cancel{
                            selectedTab = 0
                        }
                    )
                }
                                                
                //마이페이지
                EmptyView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("My Page")
                    }
                    .tag(4)
            }
        }
        .sheet(isPresented: $showingLoginView,onDismiss: {
            if UserManager.shared.isLogin{
                isLogin = true}
        }){
            LoginView(showingLoginView: $showingLoginView)
        }
    }
}

//#Preview {
//    TabBarView()
//}
