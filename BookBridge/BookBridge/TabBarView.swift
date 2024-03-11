//
//  TabBarView.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var appState: PushChatRoomRouteManager // 상태 관찰 및 뷰 전환
    @StateObject var viewModel = ChatRoomListViewModel()
    @StateObject private var userManager = UserManager.shared
    @State private var height: CGFloat = 0.0
    @State private var isShowChange = false
    @State private var isShowFind = false
    @State private var showingLoginView = false
    @State var selectedTab = 0
    @State private var previousTab = 0 // 이전에 선택한 탭을 저장하는 변수
    @State private var shouldShowActionSheet = false
    @State private var isShowingChatMessageView = false
    
    let userId : String?
    
    var body: some View {
        VStack {
            ZStack {
                NavigationStack {
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
                            
                            // 채팅방 목록 View
                            ChatRoomListView(chatRoomList: [], isComeNoticeBoard: false, uid: UserManager.shared.uid)
                                .onDisappear {
                                    shouldShowActionSheet = false
                                }
                                .tabItem {
                                    Image(systemName: "message")
                                }
                                .badge(userManager.totalNewCount)
                                .tag(1)
                                .navigationDestination(isPresented: $appState.isShowingChatMessageView) {
                                    if let chatRoomId = appState.chatRoomId {
                                        ChatMessageView(
                                            isAlarm: false,
                                            chatRoomListId: chatRoomId,
                                            chatRoomPartner: ChatPartnerModel(nickname: appState.nickname ?? " ", noticeBoardId: appState.noticeBoardId ?? "", partnerId: appState.partnerId ?? "", partnerImage: UIImage(named: "DefaultImage")!, partnerImageUrl: appState.profileURL ?? "", style: appState.style ?? "칭호 미아"),
                                            noticeBoardTitle: appState.noticeBoardTitle ?? "",
                                            uid: appState.userId ?? "")
                                    }
                                }
                            
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
                    .background(Color.white.onTapGesture {
                        self.hideKeyboard()
                    })
                    
                }
            }
        }
        .background(.red)
        .tint(Color(hex:"59AAE0"))
        .onAppear {
            userManager.updateTotalNewCount()
        }
        .onDisappear{
            appState.isShowingChatMessageView = false
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
        .onChange(of: appState.message){ _ in
            // 백그라운드에서 메세지 알람이 변경되서 올때마다 실행
            selectedTab = 1
            appState.isShowingChatMessageView = true
        }
        .sheet(isPresented: $showingLoginView, onDismiss: {
            if !userManager.isLogin {
                selectedTab = 0
            }
        }){
            LoginView(showingLoginView: $showingLoginView)
        }
    }
}
