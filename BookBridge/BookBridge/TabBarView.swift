//
//  TabBarView.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import SwiftUI

struct TabBarView: View {
    let userId : String?
    
    @StateObject private var pathModel = PostPathViewModel()
    @StateObject var postingviewModel = PostingViewModel()
    @StateObject private var userManager = UserManager.shared
    @State private var showingLoginAlert = false
    @State private var showingLoginView = false
    @State private var selectedTab = 0
    @State private var shouldShowActionSheet = false
                   
    var body: some View {
        TabView(selection: $selectedTab) {
            // 홈
            NavigationStack{
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
            }
            .tag(0)
            
            
            // 채팅
            NavigationStack{
                ChatRoomListView(uid: "joo")
            }
            .tabItem {
                Image(systemName: "message")
            }
            .tag(1)
            
            
            
            // 게시글 작성
            NavigationStack(path: $pathModel.paths){
                HomeView()
                    .navigationDestination(for: PostPathType.self){ pathType in
                        switch pathType {
                        case .findPosting:
                            ChangePostingView(selectedTab: $selectedTab)
                                .toolbar(.hidden, for: .tabBar)
                                .navigationBarBackButtonHidden()
                        case .changePosting:
                            FindPostingView(selectedTab: $selectedTab)
                                .toolbar(.hidden, for: .tabBar)
                                .navigationBarBackButtonHidden()                            
                        }
                        
                    }
            }
            .environmentObject(pathModel)
            .tabItem {
                Image(systemName: "plus.circle")
                    .font(.system(size: 40)) // 플러스 버튼은 크게 표시합니다.
            }
            .tag(2)
            .alert(isPresented: $showingLoginAlert) {
                Alert(
                    title: Text("로그인 필요"),
                    message: Text("이 기능을 사용하려면 로그인이 필요합니다."),
                    primaryButton: .default(Text("로그인"), action: {
                        showingLoginView = true
                        showingLoginAlert = false
                    }),
                    secondaryButton: .cancel{
                        selectedTab = 0
                    }
                )
            }

            
            // 책장
            NavigationStack{
                if userManager.isLogin {


                    BookShelfView(userId : userManager.uid,initialTapInfo: .wish, isBack: false)

                }
                else {
                    BookShelfView(userId: nil,initialTapInfo: .wish, isBack: false)
                        .onAppear {
//                            showingLoginAlert = true
                        }
                }
            }
            .tabItem {
                Image(systemName: "books.vertical")
            }
            .tag(3)
            .alert(isPresented: $showingLoginAlert) {
                Alert(
                    title: Text("로그인 필요"),
                    message: Text("이 기능을 사용하려면 로그인이 필요합니다."),
                    primaryButton: .default(Text("로그인"), action: {
                        showingLoginView = true
                        showingLoginAlert = false
                    }),
                    secondaryButton: .cancel{
                        selectedTab = 0
                    }
                )
            }
            
                                                
            //마이페이지
            NavigationStack{
                EmptyView()
            }
            .tabItem {
                Image(systemName: "person.circle")
            }
            .tag(4)
        
        }
        .tint(Color(hex:"59AAE0"))
        .sheet(isPresented: $showingLoginView, onDismiss: {
                

            if userManager.isLogin {
                showingLoginAlert = false
                if selectedTab == 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        shouldShowActionSheet = true
                    }
                }
            } else {                
                showingLoginAlert = true
            }
        }){
            LoginView(showingLoginView: $showingLoginView)
        }
        .actionSheet(isPresented: $shouldShowActionSheet) {
            ActionSheet(title: Text("고르세요!"), buttons: [
                .default(Text("구해요"), action: find),
                .default(Text("바꿔요"), action: changebook) ,
                .cancel{
                    selectedTab = 0
                }
            ])
        }
        .onChange(of: selectedTab) { newTab in
            // 로그인 상태 확인
            if userManager.isLogin {
                showingLoginAlert = false // 로그인 상태일 때는 알림을 띄우지 않음
                if newTab == 2 {
                    shouldShowActionSheet = true
                }
            } else {
                // 로그인 상태가 아닐 때만 알림 상태 업데이트
                showingLoginAlert = (newTab == 2 || newTab == 3)
            }
        }
    }
    
    func find() {
        pathModel.paths.append(.changePosting)
    }
    func changebook() {
        pathModel.paths.append(.findPosting)
    }
    
    
}

//#Preview {
//    TabBarView()
//}
