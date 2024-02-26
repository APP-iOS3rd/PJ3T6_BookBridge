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
    @State private var isShowPlusBtn = true
    @State private var showingLoginView = false
    @State  var selectedTab = 0
    @State private var shouldShowActionSheet = false
    
    let userId : String?
                   
    var body: some View {
        VStack {
            ZStack {
                TabView(selection: $selectedTab) {
                    // 홈
                    NavigationStack {
                        HomeView(isShowPlusBtn: $isShowPlusBtn)
                            .onDisappear {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    shouldShowActionSheet = false
                                }
                                
                                withAnimation {
                                    height = 0.0
                                }
                            }
                    }
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(0)
                    
                    // 채팅
                    NavigationStack {
                        ChatRoomListView(isShowPlusBtn: $isShowPlusBtn, chatRoomList: [], isComeNoticeBoard: false, uid: UserManager.shared.uid)
                            .onDisappear {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    shouldShowActionSheet = false
                                }
                                
                                withAnimation {
                                    height = 0.0
                                }
                            }
                    }
                    .tabItem {
                        Image(systemName: "message")
                    }
                    .tag(1)
                    
                    Spacer()
                    
                    // 책장
                    NavigationStack {
                        if userManager.isLogin {
                            BookShelfView(userId : userManager.uid,initialTapInfo: .wish, isBack: false)
                                .onDisappear {
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                        shouldShowActionSheet = false
                                    }
                                    
                                    withAnimation {
                                        height = 0.0
                                    }
                                }
                        } else {
                            BookShelfView(userId: nil,initialTapInfo: .wish, isBack: false)
                                .onDisappear {
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                        shouldShowActionSheet = false
                                    }
                                    
                                    withAnimation {
                                        height = 0.0
                                    }
                                }
                        }
                    }
                    .tabItem {
                        Image(systemName: "books.vertical")
                    }
                    .tag(2)
                                                        
                    //마이페이지
                    NavigationStack {
                        MyPageView(isShowPlusBtn: $isShowPlusBtn,selectedTab : $selectedTab)
                            .onDisappear {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    shouldShowActionSheet = false
                                }
                                
                                withAnimation {
                                    height = 0.0
                                }
                            }
                    }
                    .tabItem {
                        Image(systemName: "person.circle")
                    }
                    .tag(3)
                
                }
                .background(Color.white.onTapGesture {
                    self.hideKeyboard()
                })
                
                if isShowPlusBtn {
                    VStack {
                        Spacer()
                        
                        if shouldShowActionSheet {
                            SelectPostingView(height: $height, isAnimating: $shouldShowActionSheet, isShowChange: $isShowChange, isShowFind: $isShowFind, sortTypes: ["구해요", "바꿔요"])
                        }
                        
                        Button {
                            if userManager.isLogin {                                                                
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
                            } else {
                                // 로그인 상태가 아닐 때만 얼럿 상태 업데이트
                                showingLoginView = true
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .rotationEffect(.degrees(height == 0 ? 0 : 45))
                                .foregroundStyle(.gray)
                                .padding()
                                .padding(.horizontal)
                        }
                        Spacer().frame(height: 1)
                    }
                }
            }
        }
        .background(.red)
        .tint(Color(hex:"59AAE0"))
        .onChange(of: selectedTab) { newTab in
            if !userManager.isLogin && (newTab == 1 || newTab == 2 || newTab == 3) {
                // 비로그인 상태이며, 로그인이 필요한 탭에 접근 시
                showingLoginView = true
            }
        }
        .sheet(isPresented: $showingLoginView, onDismiss: {
            if !userManager.isLogin {
                selectedTab = 0
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
    
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//#Preview {
//    TabBarView()
//}
