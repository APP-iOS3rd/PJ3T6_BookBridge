//
//  HomeTapView.swift
//  BookBridge
//
//  Created by 노주영 on 2/6/24.
//

import SwiftUI

struct HomeTapView: View {
    @EnvironmentObject private var pathModel: TabPathViewModel
    @StateObject var viewModel: HomeViewModel
    @StateObject var locationManager = LocationManager.shared
    @State  var isInsideXmark: Bool = false
    @State  var isOutsideXmark: Bool = false
    @State private var text = ""
    @State private var showRecentSearchView = false
    @State private var offsetY: CGFloat = 0
    
    @Binding var tapCategory: TapCategory
    
    var body: some View {
        ZStack {
            VStack{
                HStack {
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(.leading, 8)
                        
                        TextField("검색어를 입력해주세요", text: $text, onCommit: {
                            if UserManager.shared.isLogin {
                                viewModel.addRecentSearch(user: UserManager.shared.uid, text: text, category: tapCategory)
                            }
                            else {
                                viewModel.filterNoticeBoards(with: text)
                            }
                            
                            isOutsideXmark = false
                            isInsideXmark = false
                            
                        })
                        .padding(7)
                        .onChange(of: text) { _ in
                            isInsideXmark = !text.isEmpty
                        }
                        .onTapGesture {
                            if text.isEmpty{
                                isOutsideXmark = true
                            }
                            else {
                                isInsideXmark = true
                                isOutsideXmark = true
                            }
                        }
                        
                        if isInsideXmark {
                            Button {
                                //TODO: 검색창 작동할 때 초기화할 것
                                isInsideXmark = false
                                text = ""
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 8)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        isOutsideXmark = true
                    }
                    
                    if isOutsideXmark  {
                        Button{
                            if isInsideXmark == false {
                                isOutsideXmark = false
                                hideKeyboard()
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                        }
                    }
                    
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                ScrollView(.vertical, showsIndicators: false) {
                    
                    
                    switch tapCategory {
                    case .find:             //TODO: imageLinks 부분 받아오기
                        
                        if text.isEmpty {
                            ForEach(viewModel.findNoticeBoards) { element in
                                if element.hopeBook.isEmpty {
                                    
                                    
//                                    NavigationLink {
//                                        
//                                        PostView(noticeBoard: element)
//                                    } label: {
//                                        VStack{
//                                            HomeListItemView(
//                                                author: "",
//                                                date: element.date,
//                                                id: element.id,
//                                                imageLinks: [],
//                                                isChange: element.isChange,
//                                                locate: element.noticeLocation,
//                                                title: element.noticeBoardTitle,
//                                                userId: element.userId,
//                                                location: element.noticeLocationName,
//                                                detail: element.noticeBoardDetail
//                                            )
//                                            
//                                            Divider()
//                                        }
//                                        
//                                    }
                                    
                                    Button {
                                        pathModel.paths.append(.postview(noticeboard: element))
                                    } label: {
                                        VStack{
                                            HomeListItemView(
                                                author: "",
                                                date: element.date,
                                                id: element.id,
                                                imageLinks: [],
                                                isChange: element.isChange,
                                                locate: element.noticeLocation,
                                                title: element.noticeBoardTitle,
                                                userId: element.userId,
                                                location: element.noticeLocationName,
                                                detail: element.noticeBoardDetail
                                            )
                                            .gesture(
                                                dragGesture
                                            )
                                            
                                            Divider()
                                        }
                                        
                                    }
                                } else {
                                    //TODO: 나중에 썸네일 이미지, 저자 바꾸기
                                    
                                    Button {
                                        pathModel.paths.append(.postview(noticeboard: element))
                                    } label: {
                                        VStack{
                                            HomeListItemView(
                                                author: element.hopeBook[0].volumeInfo.authors?[0] ?? "",
                                                date: element.date, id: element.id,
                                                imageLinks: [element.hopeBook[0].volumeInfo.imageLinks?.smallThumbnail ?? ""],
                                                isChange: element.isChange,
                                                locate: element.noticeLocation,
                                                title: element.noticeBoardTitle,
                                                userId: element.userId,
                                                location: element.noticeLocationName,
                                                detail: ""
                                            )
                                            .gesture(
                                                dragGesture
                                            )
                                            
                                            Divider()
                                        }
                                        
                                    }
                                    
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                        else {
                            ForEach(viewModel.filteredNoticeBoards) { element in
                                if element.hopeBook.isEmpty {
                                    Button {
                                        pathModel.paths.append(.postview(noticeboard: element))
                                    } label: {
                                        VStack{
                                            HomeListItemView(
                                                author: "",
                                                date: element.date,
                                                id: element.id,
                                                imageLinks: [],
                                                isChange: element.isChange,
                                                locate: element.noticeLocation,
                                                title: element.noticeBoardTitle,
                                                userId: element.userId,
                                                location: element.noticeLocationName,
                                                detail: element.noticeBoardDetail
                                            )
                                            .gesture(
                                                dragGesture
                                            )
                                            Divider()
                                        }
                                    }
                                } else {
                                    //TODO: 나중에 썸네일 이미지, 저자 바꾸기
                                    
                                    Button {
                                        pathModel.paths.append(.postview(noticeboard: element))
                                    } label: {
                                        VStack{
                                            HomeListItemView(
                                                author: element.hopeBook[0].volumeInfo.authors?[0] ?? "",
                                                date: element.date, id: element.id,
                                                imageLinks: [element.hopeBook[0].volumeInfo.imageLinks?.smallThumbnail ?? ""],
                                                isChange: element.isChange,
                                                locate: element.noticeLocation,
                                                title: element.noticeBoardTitle,
                                                userId: element.userId,
                                                location: element.noticeLocationName,
                                                detail: element.noticeBoardDetail
                                            )
                                            .gesture(
                                                dragGesture
                                            )
                                            Divider()
                                        }
                                        
                                    }
                                    
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                        
                    case .change:
                        if text.isEmpty {
                            ForEach(viewModel.changeNoticeBoards) { element in
                                Button {
                                    pathModel.paths.append(.postview(noticeboard: element))
                                } label: {
                                    VStack{
                                        
                                        HomeListItemView(
                                            author: "",
                                            date: element.date,
                                            id: element.id,
                                            imageLinks: element.noticeImageLink,
                                            isChange: element.isChange,
                                            locate: element.noticeLocation,
                                            title: element.noticeBoardTitle,
                                            userId: element.userId,
                                            location: element.noticeLocationName,
                                            detail: element.noticeBoardDetail
                                        )
                                        .gesture(
                                            dragGesture
                                        )
                                        Divider()
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            
                        }
                        else {
                            
                            ForEach(viewModel.filteredNoticeBoards) { element in
                                Button {
                                    pathModel.paths.append(.postview(noticeboard: element))
                                } label: {
                                    VStack{
                                        
                                        
                                        HomeListItemView(
                                            author: "",
                                            date: element.date,
                                            id: element.id,
                                            imageLinks: element.noticeImageLink,
                                            isChange: element.isChange,
                                            locate: element.noticeLocation,
                                            title: element.noticeBoardTitle,
                                            userId: element.userId,
                                            location: element.noticeLocationName,
                                            detail: element.noticeBoardDetail
                                        )
                                        .gesture(
                                            dragGesture
                                        )
                                        Divider()
                                    }
                                    
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                            
                        }
                        
                        
                        
                        //                case .recommend:          //TODO: 추천도서 로직 및 뷰
                        //                    EmptyView()
                    }
                }
                .refreshable {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                        viewModel.updateNoticeBoards()
                    }
                }
                
            }
            .gesture(
                dragGesture
            )
            
            
            if isOutsideXmark {
                if UserManager.shared.isLogin {
                    HomeRecentSearchView(viewModel: viewModel,isInsideXmark: $isInsideXmark,isOutsideXmark: $isOutsideXmark, text: $text)
                        .background(Color.white)
                        .zIndex(1)
                        .padding(.top, 60)
                        .opacity(showRecentSearchView ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showRecentSearchView = true
                            }
                        }
                        .onDisappear {
                            showRecentSearchView = false
                        }
                }
                else {
                    HomeRecentSearchView(viewModel: viewModel,isInsideXmark: $isInsideXmark,isOutsideXmark: $isOutsideXmark, text: $text)
                        .background(Color.white)
                        .zIndex(1)
                        .padding(.top, 60)
                        .opacity(showRecentSearchView ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showRecentSearchView = true
                            }
                        }
                        .onDisappear {
                            showRecentSearchView = false
                        }
                    
                }
                
                switch tapCategory {
                case .find:             //TODO: imageLinks 부분 받아오기
                    ForEach(viewModel.findNoticeBoards) { element in
                        if element.hopeBook.isEmpty {
                            Button {
                                pathModel.paths.append(.postview(noticeboard: element))
                            } label: {
                                VStack{
                                    HomeListItemView(
                                        author: "", date: element.date,
                                        id: element.id, imageLinks: [],
                                        isChange: element.isChange,
                                        locate: element.noticeLocation,
                                        title: element.noticeBoardTitle,
                                        userId: element.userId,
                                        location: element.noticeLocationName,
                                        detail: element.noticeBoardDetail
                                    )
                                    
                                    Divider()
                                }
                            }
                        } else {
                            //TODO: 나중에 썸네일 이미지, 저자 바꾸기
                            
                            Button {
                                pathModel.paths.append(.postview(noticeboard: element))
                            } label: {
                                VStack{
                                    HomeListItemView(
                                        author: element.hopeBook[0].volumeInfo.authors?[0] ?? "",
                                        date: element.date,
                                        id: element.id,
                                        imageLinks: [element.hopeBook[0].volumeInfo.imageLinks?.smallThumbnail ?? ""],
                                        isChange: element.isChange,
                                        locate: element.noticeLocation,
                                        title: element.noticeBoardTitle,
                                        userId: element.userId,
                                        location: element.noticeLocationName,
                                        detail: ""
                                    )
                                    Divider()
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                case .change:
                    ForEach(viewModel.changeNoticeBoards) { element in
                        Button {
                            pathModel.paths.append(.postview(noticeboard: element))
                        } label: {
                            VStack{
                                HomeListItemView(
                                    author: "",
                                    date: element.date,
                                    id: element.id,
                                    imageLinks: element.noticeImageLink,
                                    isChange: element.isChange,
                                    locate: element.noticeLocation,
                                    title: element.noticeBoardTitle,
                                    userId: element.userId,
                                    location: element.noticeLocationName,
                                    detail: element.noticeBoardDetail
                                )
                                
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    //                case .recommend:          //TODO: 추천도서 로직 및 뷰
                    //                    EmptyView()
                    
                }
            }
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        .environmentObject(viewModel)
        .onAppear {
            if UserManager.shared.isLogin {
                viewModel.fetchBookMark(user: UserManager.shared.uid)
            }
        }
        .onChange(of: tapCategory) { newValue in
            // 탭 카테고리가 변경될 때마다 필터링을 업데이트
            viewModel.currentTapCategory = newValue
            viewModel.filterNoticeBoards(with: text)
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged({ value in
                offsetY = value.translation.width * 0.5
            })
            .onEnded({ value in
                let translation = value.translation.width
                
                withAnimation(.easeInOut) {
                    if translation > 0 {
                        if translation > 10 {
                            tapCategory = .find
                        }
                    } else {
                        if translation < -10 {
                            tapCategory = .change
                        }
                    }
                    offsetY = .zero
                }
            })
    }
}

