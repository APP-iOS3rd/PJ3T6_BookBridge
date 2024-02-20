//
//  TabBarView.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var userManager = UserManager.shared
    
    @State private var height: CGFloat = 0.0
    @State private var isShowChange = false
    @State private var isShowFind = false
    @State private var showingLoginAlert = false
    @State private var showingLoginView = false
    @State private var selectedTab = 0
    @State private var shouldShowActionSheet = false
    
    let userId : String?
                   
    var body: some View {
        VStack {
            ZStack {
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
                    
                    Spacer()
                    
                    /*
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
                    */
                    
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
                                selectedTab = 2
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
                    .tag(3)
                
                }
                
                VStack {
                    Spacer()
                    
                    if shouldShowActionSheet {
                        SelectPostingView(height: $height, isAnimating: $shouldShowActionSheet, isShowChange: $isShowChange, isShowFind: $isShowFind, sortTypes: ["구해요", "바꿔요"])
                    }
                    
                    Button {
                        if shouldShowActionSheet {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                shouldShowActionSheet = false
                            }
                            
                            withAnimation {
                                height = 0.0
                            }
                        } else {
                            shouldShowActionSheet = true
                            
                            withAnimation {
                                if height == 0 {
                                    height = 100.0
                                } else {
                                    height = 0
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.gray)
                            .padding()
                            .padding(.horizontal)
                    }
                    .alert(isPresented: $showingLoginAlert) {
                        Alert(
                            title: Text("로그인 필요"),
                            message: Text("이 기능을 사용하려면 로그인이 필요합니다."),
                            primaryButton: .default(Text("로그인"), action: {
                                showingLoginView = true
                                showingLoginAlert = false
                            }),
                            secondaryButton: .cancel{
                               
                            }
                        )
                    }
                    Spacer().frame(height: 1)
                }
            }
        }
        .background(.red)
        .tint(Color(hex:"59AAE0"))
        .onChange(of: selectedTab) { newTab in
            // 로그인 상태 확인
            if userManager.isLogin {
                showingLoginAlert = false // 로그인 상태일 때는 알림을 띄우지 않음
            } else {
                // 로그인 상태가 아닐 때만 알림 상태 업데이트
                showingLoginAlert = (newTab == 1 || newTab == 2 || newTab == 3)
            }
        }
        .sheet(isPresented: $showingLoginView, onDismiss: {
            if userManager.isLogin {
                showingLoginAlert = false
            } else {
                showingLoginAlert = true
            }
        }){
            LoginView(showingLoginView: $showingLoginView)
        }
        
        .fullScreenCover(isPresented: $isShowChange, onDismiss: {
            shouldShowActionSheet = false
        }, content: {
            ChangePostingView()
        })
        
        .fullScreenCover(isPresented: $isShowFind, onDismiss: {
            shouldShowActionSheet = false
        }, content: {
            FindPostingView()
        })
    }
}

//#Preview {
//    TabBarView()
//}
