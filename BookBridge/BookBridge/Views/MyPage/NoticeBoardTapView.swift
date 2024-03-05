//
//  NoticeBoardTapView.swift
//  BookBridge
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct NoticeBoardTapView: View {
    @Binding var changeHeight: CGFloat
    @Binding var changeIndex: Int
    @Binding var findHeight: CGFloat
    @Binding var findIndex: Int
    @Binding var isFindAnimating: Bool
    @Binding var isChangeAnimating: Bool
    @Binding var selectedTab: Int
    @Binding var stack: NavigationPath
    
    @StateObject var viewModel: NoticeBoardViewModel

    var myPagePostTapType: MyPagePostTapType
    var naviTitle: String
    var sortTypes: [String]
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 10) {
                    Spacer()

                    switch myPagePostTapType {
                    case .find:
                        Button {
                            if isFindAnimating {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    isFindAnimating = false
                                }
                            } else {
                                isFindAnimating = true
                            }
                            withAnimation {
                                if sortTypes.count == 4 {
                                    if findHeight == 150.0 {
                                        findHeight = 0.0
                                    } else {
                                        findHeight = 150.0
                                    }
                                } else {
                                    if findHeight == 110.0 {
                                        findHeight = 0.0
                                    } else {
                                        findHeight = 110.0
                                    }
                                }
                            }
                        } label: {
                            HStack{
                                Text(sortTypes[findIndex])
                                    .font(.system(size: 17))
                                
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(isFindAnimating ? 180 : 360))
                                    .animation(.linear(duration: 0.3), value: isFindAnimating)
                            }
                            .padding(.trailing)
                            .foregroundStyle(.black)
                        }
                    case .change:
                        Button {
                            if isChangeAnimating {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                                    isChangeAnimating = false
                                }
                            } else {
                                isChangeAnimating = true
                            }
                            withAnimation {
                                if sortTypes.count == 4 {
                                    if changeHeight == 150.0 {
                                        changeHeight = 0.0
                                    } else {
                                        changeHeight = 150.0
                                    }
                                } else {
                                    if changeHeight == 110.0 {
                                        changeHeight = 0.0
                                    } else {
                                        changeHeight = 110.0
                                    }
                                }
                            }
                        } label: {
                            HStack{
                                Text(sortTypes[changeIndex])
                                    .font(.system(size: 17))
                                
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(isChangeAnimating ? 180 : 360))
                                    .animation(.linear(duration: 0.3), value: isChangeAnimating)
                            }
                            .padding(.trailing)
                            .foregroundStyle(.black)
                        }
                    }
                }
                .padding(.vertical, 10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    switch myPagePostTapType {
                    case .find:             //TODO: imageLinks 부분 받아오기
                        if viewModel.getfilterNoticeBoard(noticeBoard: viewModel.findNoticeBoards, index: findIndex, isRequests: sortTypes.count == 3 ? true : false).isEmpty {
                            VStack {
                                Image(uiImage: UIImage(named: "Character")!)
                                    .resizable()
                                    .frame(width: 150, height: 180)
                                
                                Text("아직 게시물이 없어요....")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(Color(hex: "767676"))
                            }
                            .padding(.top, 50)
                        } else {
                            ForEach(viewModel.getfilterNoticeBoard(noticeBoard: viewModel.findNoticeBoards, index: findIndex, isRequests: sortTypes.count == 3 ? true : false)) { element in
                                if element.hopeBook.isEmpty {
                                    NavigationLink {
                                        PostView(selectedTab: $selectedTab, stack: $stack, noticeBoard: element)
                                    } label: {
                                        NoticeBoardItemView(
                                            viewModel: viewModel,
                                            author: "",
                                            date: element.date,
                                            id: element.id,
                                            imageLinks: [],
                                            isChange: element.isChange,
                                            locate: element.noticeLocationName,
                                            naviTitle: naviTitle,
                                            title: element.noticeBoardTitle
                                        )
                                    }
                                } else {
                                    NavigationLink {
                                        PostView(selectedTab: $selectedTab, stack: $stack, noticeBoard: element)
                                    } label: {
                                        NoticeBoardItemView(
                                            viewModel: viewModel,
                                            author: element.hopeBook[0].volumeInfo.authors?[0] ?? "",
                                            date: element.date,
                                            id: element.id,
                                            imageLinks: [element.hopeBook[0].volumeInfo.imageLinks?.smallThumbnail ?? ""],
                                            isChange: element.isChange,
                                            locate: element.noticeLocationName,
                                            naviTitle: naviTitle,
                                            title: element.noticeBoardTitle
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                        
                    case .change:
                        if viewModel.getfilterNoticeBoard(noticeBoard: viewModel.changeNoticeBoards, index: changeIndex, isRequests: sortTypes.count == 3 ? true : false).isEmpty {
                            VStack {
                                Image(uiImage: UIImage(named: "Character")!)
                                    .resizable()
                                    .frame(width: 150, height: 180)
                                
                                Text("아직 게시물이 없어요....")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(Color(hex: "767676"))
                            }
                            .padding(.top, 50)
                        } else {
                            ForEach(viewModel.getfilterNoticeBoard(noticeBoard: viewModel.changeNoticeBoards, index: changeIndex, isRequests: sortTypes.count == 3 ? true : false)) { element in
                                NavigationLink {
                                    PostView(selectedTab: $selectedTab, stack: $stack, noticeBoard: element)
                                } label: {
                                    NoticeBoardItemView(
                                        viewModel: viewModel,
                                        author: "",
                                        date: element.date,
                                        id: element.id,
                                        imageLinks: element.noticeImageLink,
                                        isChange: element.isChange,
                                        locate: element.noticeLocationName,
                                        naviTitle: naviTitle,
                                        title: element.noticeBoardTitle
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
            
            if isFindAnimating {
                VStack {
                    HStack {
                        Spacer()
                        
                        NoticeBoardSortView(height: $findHeight, index: $findIndex, isAnimating: $isFindAnimating, sortTypes: sortTypes)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40)
            }
            
            if isChangeAnimating {
                VStack {
                    HStack {
                        Spacer()
                        
                        NoticeBoardSortView(height: $changeHeight, index: $changeIndex, isAnimating: $isChangeAnimating, sortTypes: sortTypes)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40)
            }
        }
    }
}
