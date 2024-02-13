//
//  HomeTapView.swift
//  BookBridge
//
//  Created by 노주영 on 2/6/24.
//

import SwiftUI

struct HomeTapView: View {
    @StateObject var viewModel: HomeViewModel
    
    @State private var isInsideXmark: Bool = false
    @State private var isOutsideXmark: Bool = false
    @State private var text = ""
    
    var tapCategory: TapCategory
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack {
                HStack{
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.leading, 8)
                    
                    TextField("검색어를 입력해주세요", text: $text)
                        .padding(7)
                        .onChange(of: text) { _ in
                            if text.isEmpty {
                                isInsideXmark = false
                            } else {
                                isInsideXmark = true
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
                .background(Color(red: 233/255, green: 233/255, blue: 233/255))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    isOutsideXmark = true
                }
                
                if isOutsideXmark {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
            switch tapCategory {
            case .find:             //TODO: imageLinks 부분 받아오기
                ForEach(viewModel.findNoticeBoards) { element in
                    if element.hopeBook.isEmpty {
                        NavigationLink {
                            PostView(noticeBoard: element)
                        } label: {
                            HomeListItemView(author: "", date: element.date, id: element.id, imageLinks: [], isChange: element.isChange, locate: element.noticeLocation, title: element.noticeBoardTitle, userId: "joo")
                        }
                    } else {
                        //TODO: 나중에 썸네일 이미지, 저자 바꾸기
                        
                        NavigationLink {
                            PostView(noticeBoard: element)
                        } label: {
                            HomeListItemView(author: element.hopeBook[0].volumeInfo.authors?[0] ?? "", date: element.date, id: element.id, imageLinks: [element.hopeBook[0].volumeInfo.imageLinks?.smallThumbnail ?? ""], isChange: element.isChange, locate: element.noticeLocation, title: element.noticeBoardTitle, userId: "joo")
                        }
                        
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
            case .change:
                ForEach(viewModel.changeNoticeBoards) { element in
                    NavigationLink {
                        PostView(noticeBoard: element)
                    } label: {
                        HomeListItemView(author: "", date: element.date, id: element.id, imageLinks: element.noticeImageLink, isChange: element.isChange, locate: element.noticeLocation, title: element.noticeBoardTitle, userId: "joo")
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
            case .recommend:          //TODO: 추천도서 로직 및 뷰
                EmptyView()
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            if UserManager.shared.isLogin {
                viewModel.fetchBookMark()
            }
        }
    }
}
