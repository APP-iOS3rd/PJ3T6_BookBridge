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
    
    var storageManager = HomeFirebaseManager.shared
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if noticeBoard.isChange {
                        TabView {
                            ForEach(url, id: \.self) { element in
                                AsyncImage(url: element) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                                        .foregroundStyle(.black)
                                } placeholder: {
                                    Rectangle()
                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                                        .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
                                }
                                
                            }
                            if url.isEmpty {
                                Image("Character")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                                    .foregroundStyle(.black)
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(height: UIScreen.main.bounds.width * 0.5625)
                        .background(
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                                .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
                        )
                        .padding(.bottom)
                    }
                    
                    HStack {
                        Image(systemName: postViewModel.user.profileURL ?? "scribble")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .background(
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
                            )
                        VStack(alignment: .leading) {
                            Text("중고도서킬러")
                                .padding(1)
                                .font(.system(size: 12))
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255)))
                            Text(postViewModel.user.nickname ?? "책벌레")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .padding(.vertical, 1)
                                .padding(.horizontal, 3)
                            Text(postViewModel.user.getSelectedLocation()?.dong ?? "")
                                .font(.system(size: 10))
                                .foregroundStyle(Color(red: 153/255, green: 153/255, blue: 153/255))
                        }
                        Spacer()
                        Text("매너점수")
                            .font(.system(size: 12))
                        Text("90점")
                            .padding(.vertical, 1)
                            .padding(.horizontal, 3)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(Color(red: 255/255, green: 222/255, blue: 201/255)))
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    //post 내용
                    VStack(alignment: .leading) {
                        Text(noticeBoard.noticeBoardTitle)
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.top)
                        Text("1시간전")
                            .font(.system(size: 10))
                            .padding(.horizontal)
                        Text(noticeBoard.noticeBoardDetail)
                            .font(.system(size: 15))
                            .padding()
                    }
                    .frame(
                        minWidth: UIScreen.main.bounds.width,
                        minHeight: 200,
                        alignment: Alignment.topLeading
                    )
                    
                    Divider()
                        .padding(.horizontal)
                    
                    //교환 희망 장소
                    VStack(alignment: .leading) {
                        HStack {
                            Text("교환 희망 장소")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            Spacer()
                            
                                                                                   
                            NavigationLink(destination: PostMapDetailView(noticeBoard: $noticeBoard)
                                .navigationBarBackButtonHidden()
                            ) {
                                Text("더보기")
                                    .foregroundStyle(Color(red: 153/255, green: 153/255, blue: 153/255))
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                       
                        
                        if noticeBoard.noticeLocation.count >= 2 {
                            PostMapView(lat: $noticeBoard.noticeLocation[0], lng: $noticeBoard.noticeLocation[1], isDetail: false)
                        }
                        
                        Text(noticeBoard.noticeLocationName)
                            .font(.system(size: 15))
                            .padding(.horizontal)
                    }
                    .frame(
                        minWidth: UIScreen.main.bounds.width,
                        minHeight: 400,
                        alignment: Alignment.topLeading
                    )
                    .padding(.bottom)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    //상대방 책장
                    VStack(alignment: .leading) {
                        Text("\(postViewModel.user.nickname ?? "책벌레")님의 책장")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .padding()
                        
                        //책장 리스트뷰
                        HStack{
                            Text("보유 도서")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            Spacer()
                            
                            NavigationLink(destination: BookShelfView(userId: postViewModel.user.id, initialTapInfo: .hold, isBack: true)
                                .navigationBarBackButtonHidden()
                            ) {
                                Text("더보기")
                                    .foregroundStyle(Color(red: 153/255, green: 153/255, blue: 153/255))
                            }
                        }
                        .padding(.horizontal)
                        
                        List{
                            ForEach(postViewModel.holdBooks) { element in
                                if let bookTitle = element.volumeInfo.title {
                                    Text(bookTitle)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding(.bottom)
                        
                        HStack{
                            Text("희망 도서")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(destination: BookShelfView(userId: postViewModel.user.id,initialTapInfo: .wish,isBack: true)
                                .navigationBarBackButtonHidden()) {
                                    Text("더보기")
                                        .foregroundStyle(Color(red: 153/255, green: 153/255, blue: 153/255))
                                }
                        }
                        .padding(.horizontal)
                        
                        List{
                            ForEach(postViewModel.wishBooks) { element in
                                if let bookTitle = element.volumeInfo.title {
                                    Text(bookTitle)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .frame(
                        minWidth: UIScreen.main.bounds.width,
                        minHeight: 300,
                        alignment: Alignment.topLeading
                    )
                    .padding(.bottom, 60)
                }
                
            }
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    isPresented = false
                }
            }

            VStack {
                HStack {
                    Spacer()
                    VStack {
                        if isPresented {
                            if UserManager.shared.uid != noticeBoard.userId {
                                Button {
                                    if UserManager.shared.isLogin {
                                        postViewModel.bookMarkToggle(id: noticeBoard.id)
                                    }
                                    isPresented.toggle()
                                } label: {
                                    Text( postViewModel.bookMarks.contains(noticeBoard.id) ? "관심목록 삭제" : "관심목록 추가")
                                        .font(.system(size: 14))
                                        .padding(1)
                                }
                                Divider()
                                    .padding(1)
                                NavigationLink {
                                    EmptyView()
                                } label: {
                                    Text("신고하기")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.red)
                                        .padding(1)
                                }
                            } else {
                                NavigationLink {
                                    if noticeBoard.isChange {
                                        ChangePostingModifyView(noticeBoard: $noticeBoard)
                                    } else {
                                        FindPostingModifyView(noticeBoard: $noticeBoard)
                                    }
                                } label: {
                                    Text("수정하기")
                                        .font(.system(size: 14))
                                        .padding(1)
                                }
                                Divider()
                                    .padding(1)
                                Button {
                                    
                                } label: {
                                    Text("삭제하기")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color.red)
                                        .padding(1)
                                }
                            }
                        }
                    }
                    .frame(width: 110, height: isPresented ? 80 : 0)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .foregroundColor(Color(red: 230/255, green: 230/255, blue: 230/255))
                    )
                    .padding(.trailing)
                }
                Spacer()
            }
            
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

struct PostMapView: UIViewRepresentable {
    
    @Binding var lat: Double // 모델 좌표 lat
    @Binding var lng: Double // 모델 좌표 lng
    var isDetail: Bool
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView()
        
        if !isDetail {
            mapView.mapView.isScrollGestureEnabled = false
            mapView.mapView.isZoomGestureEnabled = false
            mapView.showZoomControls = false
        }
        
        // 마커 좌표를 설정
        let markerCoord = NMGLatLng(lat: lat, lng: lng)
        
        // 내 위치 활성화 버튼을 표시
        //        mapView.showLocationButton = true
        
        // 초기 카메라 위치를 마커의 위치로 설정하고 줌 레벨을 조정
        let cameraUpdate = NMFCameraUpdate(scrollTo: markerCoord, zoomTo: 15)
        mapView.mapView.moveCamera(cameraUpdate)
        
        // 마커를 생성하고 지도에 표시
        let marker = NMFMarker(position: markerCoord)
        marker.mapView = mapView.mapView
        
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        //        _ = NMGLatLng(lat: lat, lng: lng)
        //        _ = NMFCameraUpdate(scrollTo: newMyCoord)
    }
}
