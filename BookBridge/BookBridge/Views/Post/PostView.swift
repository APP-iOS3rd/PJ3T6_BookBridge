//
//  ChangePostView.swift
//  BookBridge
//
//  Created by jonghyun baik on 2/7/24.
//

import SwiftUI
import NMapsMap

struct PostView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var pathModel: TabPathViewModel
    @Binding var selectedTab : Int
    @StateObject var postViewModel = PostViewModel()    
    @State var noticeBoard: NoticeBoard
    
    
    @State private var isPresented = false
    @State private var showingLoginView = false
    @State private var verticalOffset: CGPoint = .zero
    
    var storageManager = HomeFirebaseManager.shared
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                    ScrollView {
                        CustomScrollView(offset: $verticalOffset, showIndicators: true, axis: .vertical) {
                        VStack {
                            if noticeBoard.isChange {
                                PostImageView(urlString: noticeBoard.noticeImageLink)
                            }
                            
                            PostUserInfoView(postViewModel: postViewModel, noticeBoard: $noticeBoard, selectedTab: $selectedTab)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            //post 내용
                            PostContent(noticeBoard: $noticeBoard)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            if !noticeBoard.isChange {
                                // 희망도서 부분
                                PostHopeBookListView(viewModel: postViewModel, hopeBooks: $postViewModel.noticeboardsihBooks)
                                Divider()
                                    .padding(.horizontal)
                            }
                            
                            //상대방 책장
                            PostUserBookshelf(postViewModel: postViewModel)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            if noticeBoard.isAddLocation ?? false {
                                // 교환 희망 장소
                                PostChangeLocationView(
                                    postViewModel: postViewModel,
                                    noticeBoard: $noticeBoard
                                )
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: geometry.size.height - 65)
            }
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    isPresented = false
                }
            }
            
            PostMenuBtnsView(
                isPresented: $isPresented,
                noticeBoard: $noticeBoard,
                postViewModel: postViewModel
            )
            
            VStack {
                Spacer()
                
                if UserManager.shared.uid == noticeBoard.userId {
                    Button {
                        pathModel.paths.append(.chatRoomList(
                            chatRoomList: postViewModel.chatRoomList, isComeNoticeBoard: true, uid: UserManager.shared.uid
                        ))
                    } label: {
                        Text("대화중인 채팅방 \(postViewModel.chatRoomList.count)")
                            .padding(.top, 5)
                            .font(.system(size: 20, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                            .foregroundStyle(Color.white)
                            .background(Color(hex: "59AAE0"))
                    }
                    //                    NavigationLink {
                    //                        ChatRoomListView(
                    //                            chatRoomList: postViewModel.chatRoomList,
                    //                            isComeNoticeBoard: true,
                    //                            uid: UserManager.shared.uid)
                    //                    } label: {
                    //                        Text("대화중인 채팅방 \(postViewModel.chatRoomList.count)")
                    //                            .padding(.top, 5)
                    //                            .font(.system(size: 20, weight: .semibold))
                    //                            .frame(maxWidth: .infinity)
                    //                            .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                    //                            .foregroundStyle(Color.white)
                    //                            .background(Color(hex: "59AAE0"))
                    //                    }
                } else {
                    if noticeBoard.state == 1 {
                        if UserManager.shared.uid != "" {
                            if noticeBoard.reservationId == UserManager.shared.uid {
                                Button {
                                    postViewModel.getOutChatRoomId(noticeBoardId: noticeBoard.id) { chatId in
                                        pathModel.paths.append(.chatMessage(
                                            isAlarm: postViewModel.isChatAlarm,
                                            chatRoomListId: chatId,
                                            chatRoomPartner: ChatPartnerModel(
                                                nickname: postViewModel.user.nickname ?? "닉네임 미아",
                                                noticeBoardId: noticeBoard.id,
                                                partnerId: noticeBoard.userId,
                                                partnerImage: postViewModel.userUIImage, partnerImageUrl: postViewModel.user.profileURL ?? "",
                                                reviews: postViewModel.user.reviews ?? [0, 0, 0],
                                                style: (postViewModel.user.style == "" ? "칭호없음" : postViewModel.user.style) ?? "칭호없음"
                                            ),
                                            noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                            uid: UserManager.shared.uid))
                                    }
                                } label: {
                                    Text("채팅하기")
                                        .padding(.top, 5)
                                        .font(.system(size: 20, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                        .foregroundStyle(Color.white)
                                        .background(Color(hex: "59AAE0"))
                                }
                                //                                NavigationLink {
                                //                                    ChatMessageView(
                                //                                        chatRoomListId: postViewModel.userChatRoomId,
                                //                                        chatRoomPartner: ChatPartnerModel(
                                //                                            nickname: postViewModel.user.nickname ?? "닉네임 미아",
                                //                                            noticeBoardId: noticeBoard.id,
                                //                                            partnerId: noticeBoard.userId,
                                //                                            partnerImage: postViewModel.userUIImage, partnerImageUrl: postViewModel.user.profileURL ?? "",
                                //                                            reviews: postViewModel.user.reviews ?? [0, 0, 0],
                                //                                            style: (postViewModel.user.style == "" ? "칭호없음" : postViewModel.user.style) ?? "칭호없음"
                                //                                        ),
                                //                                        noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                //                                        uid: UserManager.shared.uid
                                //                                    )
                                //                                } label: {
                                //                                    Text("채팅하기")
                                //                                        .padding(.top, 5)
                                //                                        .font(.system(size: 20, weight: .semibold))
                                //                                        .frame(maxWidth: .infinity)
                                //                                        .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                //                                        .foregroundStyle(Color.white)
                                //                                        .background(Color(hex: "59AAE0"))
                                //                                }
                            } else {
                                Text("예약중")
                                    .padding(.top, 5)
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                    .foregroundStyle(Color.white)
                                    .background(Color(.lightGray))
                            }
                        } else {
                            Text("예약중")
                                .padding(.top, 5)
                                .font(.system(size: 20, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                .foregroundStyle(Color.white)
                                .background(Color(.lightGray))
                        }
                    } else if noticeBoard.state == 2 {
                        if UserManager.shared.uid != "" {
                            if noticeBoard.reservationId == UserManager.shared.uid {
                                //                                NavigationLink {
                                //                                    ChatMessageView(
                                //                                        chatRoomListId: postViewModel.userChatRoomId,
                                //                                        chatRoomPartner: ChatPartnerModel(
                                //                                            nickname: postViewModel.user.nickname ?? "닉네임 미아",
                                //                                            noticeBoardId: noticeBoard.id,
                                //                                            partnerId: noticeBoard.userId,
                                //                                            partnerImage: postViewModel.userUIImage, partnerImageUrl: postViewModel.user.profileURL ?? "",
                                //                                            reviews: postViewModel.user.reviews ?? [0, 0, 0],
                                //                                            style: (postViewModel.user.style == "" ? "칭호없음" : postViewModel.user.style) ?? "칭호없음"
                                //                                        ),
                                //                                        noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                //                                        uid: UserManager.shared.uid
                                //                                    )
                                //                                }
                                Button {
                                    postViewModel.getOutChatRoomId(noticeBoardId: noticeBoard.id) { chatId in
                                        pathModel.paths.append(.chatMessage(
                                            isAlarm: postViewModel.isChatAlarm,
                                            chatRoomListId: chatId,
                                            chatRoomPartner: ChatPartnerModel(
                                                nickname: postViewModel.user.nickname ?? "닉네임 미아",
                                                noticeBoardId: noticeBoard.id,
                                                partnerId: noticeBoard.userId,
                                                partnerImage: postViewModel.userUIImage, partnerImageUrl: postViewModel.user.profileURL ?? "",
                                                reviews: postViewModel.user.reviews ?? [0, 0, 0],
                                                style: (postViewModel.user.style == "" ? "칭호없음" : postViewModel.user.style) ?? "칭호없음"
                                            ),
                                            noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                            uid: UserManager.shared.uid))
                                    }
                                } label: {
                                    Text("채팅하기")
                                        .padding(.top, 5)
                                        .font(.system(size: 20, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                        .foregroundStyle(Color.white)
                                        .background(Color(hex: "59AAE0"))
                                }
                            } else {
                                Text("교환완료")
                                    .padding(.top, 5)
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                    .foregroundStyle(Color.white)
                                    .background(Color(.lightGray))
                            }
                        } else {
                            Text("교환완료")
                                .padding(.top, 5)
                                .font(.system(size: 20, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                .foregroundStyle(Color.white)
                                .background(Color(.lightGray))
                        }
                    } else {
                        if  UserManager.shared.uid != "" {
                            //채팅한 적이 없는 경우
                            if postViewModel.chatRoomList.isEmpty {
                                //                                NavigationLink {
                                //                                    ChatMessageView(
                                //                                        chatRoomListId: "",
                                //                                        chatRoomPartner: ChatPartnerModel(
                                //                                            nickname: postViewModel.user.nickname ?? "닉네임 미아",
                                //                                            noticeBoardId: noticeBoard.id,
                                //                                            partnerId: noticeBoard.userId,
                                //                                            partnerImage: postViewModel.userUIImage, partnerImageUrl: postViewModel.user.profileURL ?? "",
                                //                                            reviews: postViewModel.user.reviews ?? [0, 0, 0],
                                //                                            style: (postViewModel.user.style == "" ? "칭호없음" : postViewModel.user.style) ?? "칭호없음"
                                //                                        ),
                                //                                        noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                //                                        uid: UserManager.shared.uid
                                //                                    )
                                //                                }
                                
                                
                                Button {
                                    postViewModel.getOutChatRoomId(noticeBoardId: noticeBoard.id) { chatId in
                                        pathModel.paths.append(.chatMessage(
                                            isAlarm: postViewModel.isChatAlarm,
                                            chatRoomListId: chatId,
                                            chatRoomPartner: ChatPartnerModel(
                                                nickname: postViewModel.user.nickname ?? "닉네임 미아",
                                                noticeBoardId: noticeBoard.id,
                                                partnerId: noticeBoard.userId,
                                                partnerImage: postViewModel.userUIImage, partnerImageUrl: postViewModel.user.profileURL ?? "",
                                                reviews: postViewModel.user.reviews ?? [0, 0, 0],
                                                style: (postViewModel.user.style == "" ? "칭호없음" : postViewModel.user.style) ?? "칭호없음"
                                            ),
                                            noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                            uid: UserManager.shared.uid))
                                    }
                                } label: {
                                    Text("채팅하기")
                                        .padding(.top, 5)
                                        .font(.system(size: 20, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                        .foregroundStyle(Color.white)
                                        .background(Color(hex: "59AAE0"))
                                }
                            } else {
                                //채팅한 적이 있는 경우
                                //                                NavigationLink {
                                //                                    ChatMessageView(
                                //                                        chatRoomListId: postViewModel.userChatRoomId,
                                //                                        chatRoomPartner: ChatPartnerModel(
                                //                                            nickname: postViewModel.user.nickname ?? "닉네임 미아",
                                //                                            noticeBoardId: noticeBoard.id,
                                //                                            partnerId: noticeBoard.userId,
                                //                                            partnerImage: postViewModel.userUIImage, partnerImageUrl: postViewModel.user.profileURL ?? "",
                                //                                            reviews: postViewModel.user.reviews ?? [0, 0, 0],
                                //                                            style: (postViewModel.user.style == "" ? "칭호없음" : postViewModel.user.style) ?? "칭호없음"
                                //                                        ),
                                //                                        noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                //                                        uid: UserManager.shared.uid
                                //                                    )
                                //                                }
                                Button {
                                    postViewModel.getOutChatRoomId(noticeBoardId: noticeBoard.id) { chatId in
                                        pathModel.paths.append(.chatMessage(
                                            isAlarm: postViewModel.isChatAlarm,
                                            chatRoomListId: postViewModel.userChatRoomId,
                                            chatRoomPartner: ChatPartnerModel(
                                                nickname: postViewModel.user.nickname ?? "닉네임 미아",
                                                noticeBoardId: noticeBoard.id,
                                                partnerId: noticeBoard.userId,
                                                partnerImage: postViewModel.userUIImage, partnerImageUrl: postViewModel.user.profileURL ?? "",
                                                reviews: postViewModel.user.reviews ?? [0, 0, 0],
                                                style: (postViewModel.user.style == "" ? "칭호없음" : postViewModel.user.style) ?? "칭호없음"
                                            ),
                                            noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                            uid: UserManager.shared.uid))
                                    }
                                } label: {
                                    Text("채팅하기")
                                        .padding(.top, 5)
                                        .font(.system(size: 20, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                        .foregroundStyle(Color.white)
                                        .background(Color(hex: "59AAE0"))
                                }
                            }
                        } else {
                            Button {
                                showingLoginView = true
                            } label: {
                                Text("채팅하기")
                                    .padding(.top, 5)
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60, alignment: Alignment.center).ignoresSafeArea()
                                    .foregroundStyle(Color.white)
                                    .background(Color(hex: "59AAE0"))
                            }
                        }
                    }
                }
            }
            .frame(alignment: Alignment.bottom)
        }
        .onAppear {
            Task {
                postViewModel.fetchNoticeBoard(noticeBoardId: noticeBoard.id)
                postViewModel.gettingUserInfo(userId: noticeBoard.userId)
                postViewModel.gettingUserBookShelf(userId: noticeBoard.userId, collection: "holdBooks")
                postViewModel.gettingUserBookShelf(userId: noticeBoard.userId, collection: "wishBooks")
                
                if UserManager.shared.isLogin {
                    postViewModel.fetchChatList(noticeBoardId: noticeBoard.id)
                    postViewModel.fetchBookMark()
                    postViewModel.getChatRoomId(noticeBoardId: noticeBoard.id) { isComplete, isAlarm, chatRoomId in
                        if isComplete {
                            postViewModel.userChatRoomId = chatRoomId
                            postViewModel.isChatAlarm = isAlarm
                        }
                    }
                }
            }
        }
        //        .navigationTitle(noticeBoard.isChange ? "바꿔요" : "구해요")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
//        .navigationTitle("Offset: \(String(format: "%.1f", verticalOffset.y))")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 10) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(noticeBoard.isChange ? (verticalOffset.y < 0 ? .black : .white) : .black)
                    }
                    Button {
                        pathModel.paths.removeAll()
                        selectedTab = 0
                    } label: {
                        Image(systemName: "house")
                            .foregroundStyle(noticeBoard.isChange ? (verticalOffset.y < 0 ? .black : .white) : .black)
                    }
                }
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isPresented.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(noticeBoard.isChange ? (verticalOffset.y < 0 ? .black : .white) : .black)
                }
            }
        }
        .sheet(isPresented: $showingLoginView){
            LoginView(showingLoginView: $showingLoginView)
        }
        // 여기 문제 있어요
        .edgesIgnoringSafeArea(noticeBoard.isChange ? .top : [])
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

struct CustomScrollView<Content: View>: View {
    var content: Content
    
    @Binding var offset: CGPoint
    var showIndicators: Bool
    var axis: Axis.Set
    
    init(offset: Binding<CGPoint>, showIndicators: Bool, axis: Axis.Set, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._offset = offset
        self.showIndicators = showIndicators
        self.axis = axis
    }
    
    @State var startOffset: CGPoint = .zero
    
    var body: some View {
        ScrollView(axis, showsIndicators: showIndicators) {
            
            content
                .overlay(
                    GeometryReader { proxy -> Color in
                        
                        let rect = proxy.frame(in: .global)
                        
                        if startOffset == .zero {
                            DispatchQueue.main.async {
                                startOffset = CGPoint(x: rect.minX, y: rect.minY)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            if startOffset == .zero {
                                startOffset = CGPoint(x: rect.minX, y: rect.minY)
                            }
                            self.offset = CGPoint(x: startOffset.x - rect.minX, y: startOffset.y - rect.minY)
                            
                            self.offset = CGPoint(x: rect.minX, y: rect.minY)
                        }
                        return Color.clear
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 0)
                    
                    ,alignment: .top
                )
        }
    }
}
