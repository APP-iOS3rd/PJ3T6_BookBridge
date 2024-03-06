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
    var sortTypes: [String]
    var otherUser: UserModel?
    
    var body: some View {
        VStack {
            TapAnimation()
            
            NoticeBoardTapView(changeHeight: $changeHeight, changeIndex: $changeIndex, findHeight: $findHeight, findIndex: $findIndex, isFindAnimating: $isFindAnimating, isChangeAnimating: $isChangeAnimating, viewModel: viewModel, sortTypes: sortTypes, myPagePostTapType: selectedPicker)
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
                    Button {
                        pathModel.paths.removeAll()
                    } label: {
                        Image(systemName: "house")
                            .foregroundStyle( .black)
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
