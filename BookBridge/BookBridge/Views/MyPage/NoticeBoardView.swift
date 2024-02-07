//
//  NoticeBoardView.swift
//  BookBridge
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct NoticeBoardView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = NoticeBoardViewModel()
    
    @State private var selectedPicker: MyPagePostTapType = .find
    
    @State private var findHeight: CGFloat = 0.0
    @State private var changeHeight: CGFloat = 0.0
    @State private var findIndex: Int = 0
    @State private var changeIndex: Int = 0
    @State private var isFindAnimating: Bool = false
    @State private var isChangeAnimating: Bool = false
    
    @Namespace private var animation
    
    let sortTypes: [String] = ["전체", "진행중", "예약중", "교환완료"]
    
    var naviTile: String
    
    var body: some View {
        VStack {
            TapAnimation()
            
            NoticeBoardTapView(viewModel: viewModel, findHeight: $findHeight, changeHeight: $changeHeight, findIndex: $findIndex, changeIndex: $changeIndex, isFindAnimating: $isFindAnimating, isChangeAnimating: $isChangeAnimating, sortTypes: sortTypes, myPagePostTapType: selectedPicker)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(naviTile)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            viewModel.gettingFindNoticeBoards()
            viewModel.gettingChangeNoticeBoards()
        }
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
