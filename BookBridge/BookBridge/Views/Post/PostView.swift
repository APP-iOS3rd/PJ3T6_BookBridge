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
    
    @Binding var isShowPlusBtn: Bool
    
    @State private var isPresented = false
    @State var noticeBoard: NoticeBoard
    @State var url: [URL] = []
    @StateObject private var postViewModel = PostViewModel()
    @StateObject var reportVM = ReportViewModel()
    
    var storageManager = HomeFirebaseManager.shared
    
    var body: some View {
        ZStack {
            ScrollView() {
                VStack {
                    if noticeBoard.isChange {
                        PostImageView(url: $url)
                    }
                    
                    PostUserInfoView(postViewModel: postViewModel)
                                        
                    Divider()
                        .padding(.horizontal)
                    
                    //post 내용
                    PostContent(noticeBoard: $noticeBoard)
                                        
                    Divider()
                        .padding(.horizontal)
                                        
                    
                    //상대방 책장
                    PostUserBookshelf(postViewModel: postViewModel)
                                        
                    Divider()
                        .padding(.horizontal)
                    
                    // 교환 희망 장소
                    PostChangeLocationView(
                        postViewModel: postViewModel,
                        noticeBoard: $noticeBoard
                    )
                }
                .frame(maxWidth: .infinity)
            }
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    isPresented = false
                }
            }
            
            PostMenuBtnsView(
                postViewModel: postViewModel,
                reportVM: reportVM,
                isPresented: $isPresented,
                noticeBoard: $noticeBoard
            )
            
            VStack {
                Spacer()
                
                if UserManager.shared.uid == noticeBoard.userId {
                    NavigationLink {
                        ChatRoomListView(isShowPlusBtn: $isShowPlusBtn, isComeNoticeBoard: true, uid: UserManager.shared.uid)
                    } label: {
                        Text("대화중인 채팅방 \(postViewModel.chatRoomList.count)")
                            .foregroundStyle(Color.white)
                            .frame(width: UIScreen.main.bounds.width, height: 57, alignment: Alignment.center)
                            .background(Color(hex: "59AAE0"))
                            .padding(1)
                    }
                } else {
                    if noticeBoard.state == 1 {
                        Text("예약중")
                            .foregroundStyle(Color.white)
                            .frame(width: UIScreen.main.bounds.width, height: 57, alignment: Alignment.center)
                            .background(Color(hex: "59AAE0"))
                            .padding(1)
                    }
                    else if noticeBoard.state == 0 {
                        if postViewModel.chatRoomList.isEmpty {
                            NavigationLink {
                                if let image = UIImage(contentsOfFile: "DefaultImage") {
                                    ChatMessageView(
                                        isShowPlusBtn: $isShowPlusBtn,
                                        chatRoomListId: UUID().uuidString,
                                        noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                        chatRoomPartner: ChatPartnerModel(
                                            nickname: postViewModel.user.nickname ?? "책벌레",
                                            noticeBoardId: noticeBoard.id,
                                            partnerId: noticeBoard.userId,
                                            partnerImage: image,
                                            style: "중고귀신"
                                        ),
                                        uid: UserManager.shared.uid
                                    )
                                }
                                
                            } label: {
                                Text("채팅하기")
                                    .foregroundStyle(Color.white)
                                    .frame(width: UIScreen.main.bounds.width, height: 57, alignment: Alignment.center)
                                    .background(Color(hex: "59AAE0"))
                                    .padding(1)
                            }
                        } else {
                            NavigationLink {
                                if let image = UIImage(contentsOfFile: "DefaultImage") {
                                    ChatMessageView(
                                        isShowPlusBtn: $isShowPlusBtn,
                                        chatRoomListId: postViewModel.chatRoomList.first!,
                                        noticeBoardTitle: noticeBoard.noticeBoardTitle,
                                        chatRoomPartner: ChatPartnerModel(
                                            nickname: postViewModel.user.nickname ?? "책별레",
                                            noticeBoardId: noticeBoard.id,
                                            partnerId: noticeBoard.userId,
                                            partnerImage: image,
                                            style: "중고귀신"
                                        ),
                                        uid: UserManager.shared.uid
                                    )
                                }
                            } label: {
                                Text("채팅하기")
                                    .foregroundStyle(Color.white)
                                    .frame(width: UIScreen.main.bounds.width, height: 57, alignment: Alignment.center)
                                    .background(Color(hex: "59AAE0"))
                                    .padding(1)
                            }
                        }
                    } else {
                        Text("교환 완료")
                            .foregroundStyle(Color.white)
                            .frame(width: UIScreen.main.bounds.width, height: 57, alignment: Alignment.center)
                            .background(Color.gray)
                            .padding(1)
                    }
                }
            }
            .frame(alignment: Alignment.bottom)
        }
        .onAppear {
            // 바꿔요 게시물 이미지 업로드
            StorageManager.fetchImageURL(address: "NoticeBoard/\(noticeBoard.id)") { urls in
                if let urls = urls {
                    self.url = urls
                }
            }
            
            isShowPlusBtn = false
            
            if !noticeBoard.noticeImageLink.isEmpty && noticeBoard.isChange {
                Task {
                    for image in noticeBoard.noticeImageLink {
                        try await storageManager.downloadImage(noticeiId: noticeBoard.id, imageId: image) { url in
                            self.url.append(url)
                        }
                        
                    }
                }
            }
            
            Task {
                postViewModel.gettingUserInfo(userId: noticeBoard.userId)
                postViewModel.gettingUserBookShelf(userId: noticeBoard.userId, collection: "holdBooks")
                postViewModel.gettingUserBookShelf(userId: noticeBoard.userId, collection: "wishBooks")
                if UserManager.shared.isLogin {
                    postViewModel.fetchChatList(noticeBoardId: noticeBoard.id)
                    postViewModel.fetchBookMark()
                }
            }
            if noticeBoard.noticeLocation.count >= 2 {
                //                myCoord = (noticeBoard.noticeLocation[0], noticeBoard.noticeLocation[1])
            }
        }
        .navigationTitle(noticeBoard.isChange ? "바꿔요" : "구해요")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isPresented.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
    }
}
