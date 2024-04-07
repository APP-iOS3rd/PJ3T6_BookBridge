//
//  NoticeBoardView.swift
//  BookBridge
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct NoticeBoardView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var pathModel: TabPathViewModel
    @StateObject var viewModel = NoticeBoardViewModel()
    @Binding  var selectedTab : Int
    @State private var selectedPicker: MyPagePostTapType = .find
    
    @State private var changeHeight: CGFloat = 0.0
    @State private var changeIndex: Int = 0
    @State private var findHeight: CGFloat = 0.0
    @State private var findIndex: Int = 0
    @State private var isFindAnimating: Bool = false
    @State private var isChangeAnimating: Bool = false
    
    @Namespace private var animation
    
    var naviTitle: String
    var noticeBoardArray: [String]
    var otherUser: UserModel?
    var sortTypes: [String]
    
    var body: some View {
        VStack {
            TapAnimation()
            
            NoticeBoardTapView(changeHeight: $changeHeight, changeIndex: $changeIndex, findHeight: $findHeight, findIndex: $findIndex, isFindAnimating: $isFindAnimating, isChangeAnimating: $isChangeAnimating, selectedTab: $selectedTab, viewModel: viewModel, myPagePostTapType: selectedPicker, naviTitle: naviTitle, sortTypes: sortTypes)
                .offset(x: dragOffset.width, y: 0)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(otherUser == nil ? naviTitle : "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 10){
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                    
                    if otherUser != nil {
                        Button {
                            pathModel.paths.removeAll()
                            selectedTab = 0
                        } label: {
                            Image(systemName: "house")
                                .foregroundStyle( .black)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchBookMark()
            viewModel.gettingFindNoticeBoards(whereIndex: naviTitle == "내 게시물" ? 0 : 1, noticeBoardArray: noticeBoardArray, otherUser: otherUser)
            viewModel.gettingChangeNoticeBoards(whereIndex: naviTitle == "내 게시물" ? 0 : 1, noticeBoardArray: noticeBoardArray, otherUser: otherUser)
        }
        .toolbar(.hidden, for: .tabBar)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    let horizontalTranslation = value.translation.width
                    let threshold: CGFloat = 100 // 드래그로 이동할 최소한의 거리
                    if horizontalTranslation > threshold {
                        // 오른쪽으로 드래그되었을 때
                        if let currentIndex = MyPagePostTapType.allCases.firstIndex(of: selectedPicker), currentIndex > 0 {
                            selectedPicker = MyPagePostTapType.allCases[currentIndex - 1]
                        }
                    } else if horizontalTranslation < -threshold {
                        // 왼쪽으로 드래그되었을 때
                        if let currentIndex = MyPagePostTapType.allCases.firstIndex(of: selectedPicker), currentIndex < MyPagePostTapType.allCases.count - 1 {
                            selectedPicker = MyPagePostTapType.allCases[currentIndex + 1]
                        }
                    }
                    dragOffset = .zero
                }
        )
    }
}

extension NoticeBoardView {
    @ViewBuilder
    private func TapAnimation() -> some View {
        HStack {
            ForEach(MyPagePostTapType.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.title3)
                        .frame(maxWidth: .infinity/3, minHeight: 50)
                        .foregroundColor(selectedPicker == item ? .black : .gray)

                    if selectedPicker == item {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "info", in: animation)
                            .padding(.bottom, 0)
                    }
                    
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                        
                        switch item {
                        case .find:
                            isChangeAnimating = false
                            changeHeight = 0.0
                        case .change:
                            isFindAnimating = false
                            findHeight = 0.0
                        }
                    }
                }
            }
        }
        .overlay(
            Rectangle()
                .frame(width: nil, height: 1, alignment: .bottom)
                .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255)), alignment: .bottom)
    }
}
