//
//  TabBarView.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var userManager = UserManager.shared
    @StateObject private var pathModel = TabPathViewModel()
    @State var selectedTab = 0
    @State private var height: CGFloat = 0.0
    @State private var isShowChange = false
    @State private var isShowFind = false
    @State private var showingLoginView = false
    @State private var showingNewBiView = false
    @State private var previousTab = 0 // 이전에 선택한 탭을 저장하는 변수
    @State private var shouldShowActionSheet = false
    
    let userId : String?
    
    var body: some View {
        ZStack {
            VStack {
                NavigationStack(path: $pathModel.paths) {
                    ZStack {
                        TabView(selection: $selectedTab) {
                            Group {
                                // 홈
                                HomeView()
                                    .onDisappear {
                                        shouldShowActionSheet = false
                                    }
                                    .tabItem {
                                        Image(systemName: "house")
                                    }
                                    .tag(0)
                                
                                // 채팅
                                ChatRoomListView(chatRoomList: [], isComeNoticeBoard: false, uid: UserManager.shared.uid)
                                    .onDisappear {
                                        shouldShowActionSheet = false
                                    }
                                    .tabItem {
                                        Image(systemName: "message")
                                    }
                                    .badge(userManager.totalNewCount)
                                    .tag(1)
                                
                                HomeView()
                                    .tabItem {
                                        Image(systemName: "plus.circle")
                                    }
                                    .sheet(isPresented: $shouldShowActionSheet) {
                                        SelectPostingView(isShowChange: $isShowChange, isShowFind: $isShowFind, shouldShowActionSheet: $shouldShowActionSheet)
                                            .presentationDetents([.height(250)])
                                            .ignoresSafeArea(.all)
                                        
                                    }
                                    .tag(2)
                                
                                // 책장
                                if userManager.isLogin {
                                    BookShelfView(userId : userManager.uid,initialTapInfo: .wish, isBack: false, ismore: false)
                                        .onDisappear {
                                            shouldShowActionSheet = false
                                        }
                                        .tabItem {
                                            Image(systemName: "books.vertical")
                                        }
                                        .tag(3)
                                } else {
                                    BookShelfView(userId: nil,initialTapInfo: .wish, isBack: false, ismore:false)
                                        .onDisappear {
                                            shouldShowActionSheet = false
                                        }
                                        .tabItem {
                                            Image(systemName: "books.vertical")
                                        }
                                        .tag(3)
                                }
                                
                                //마이페이지
                                MyPageView(selectedTab : $selectedTab)
                                    .onDisappear {
                                        shouldShowActionSheet = false
                                    }
                                    .tabItem {
                                        Image(systemName: "person.circle")
                                    }
                                    .tag(4)
                            }
                            .toolbarBackground(.visible, for: .tabBar)
                        }
                        .navigationDestination(for: TabPathType.self){pathType in
                            switch pathType {
                            case let .mypage(other):
                                MyPageView(selectedTab: $selectedTab, otherUser: other)
                                
                            case let .postview(noticeboard):
                                PostView(selectedTab: $selectedTab, noticeBoard: noticeboard)
                                
                            case let .chatMessage(isAlarm?, chatRoomListId, chatRoomPartner, noticeBoardTitle, uid):
                                ChatMessageView(
                                    isAlarm: isAlarm,
                                    chatRoomListId: chatRoomListId,
                                    chatRoomPartner: chatRoomPartner,
                                    noticeBoardTitle: noticeBoardTitle,
                                    uid: uid
                                )
                                
                            case let .chatRoomList(chatRoomList, isComeNoticeBoard, uid):
                                ChatRoomListView(chatRoomList: chatRoomList, isComeNoticeBoard: isComeNoticeBoard, uid: uid)
                                
                            case .chatMessage(isAlarm: .none, chatRoomListId: let chatRoomListId, chatRoomPartner: let chatRoomPartner, noticeBoardTitle: let noticeBoardTitle, uid: let uid):
                                ChatMessageView(
                                    chatRoomListId: chatRoomListId,
                                    chatRoomPartner: chatRoomPartner,
                                    noticeBoardTitle: noticeBoardTitle,
                                    uid: uid
                                )
                                
                            case let .report(ischat):
                                ReportView(ischat: ischat)
                            }
                        }
                        .background(Color.white.onTapGesture {
                            self.hideKeyboard()
                        })
                    }
                }
            }
            if showingNewBiView && !showingLoginView {
                StyleGetView(style: .newBi)
            }
        }
        .environmentObject(pathModel)
        .background(.red)
        .tint(Color(hex:"59AAE0"))
        .onAppear {
            userManager.updateTotalNewCount()
        }
        .onChange(of: selectedTab) { newTab in
            if !userManager.isLogin && (newTab == 1 || newTab == 2 || newTab == 3 || newTab == 4) {
                // 비로그인 상태이며, 로그인이 필요한 탭에 접근 시
                showingLoginView = true
            } else {
                if newTab == 2 {
                    // 탭 2를 선택한 경우, 이전에 선택한 탭을 활성화
                    selectedTab = previousTab
                    shouldShowActionSheet = true
                    
                } else {
                    // 탭 2가 아닌 다른 탭을 선택한 경우, 이전에 선택한 탭을 갱신
                    previousTab = newTab
                }
            }
        }
        .sheet(isPresented: $showingLoginView, onDismiss: {
            if !userManager.isLogin {
                selectedTab = 0
            } else {
                if userManager.isDoSignUp {
                    showingNewBiView = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        userManager.isDoSignUp = false
                        showingNewBiView = false
                    }
                }
            }
        }){
            LoginView(showingLoginView: $showingLoginView)
        }
    }
}
