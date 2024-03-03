//
//  SelectPostingView.swift
//  BookBridge
//
//  Created by 노주영 on 2/20/24.
//

import SwiftUI

struct SelectPostingView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isShowChange: Bool
    @Binding var isShowFind: Bool
    @Binding var shouldShowActionSheet: Bool
    
    let sortTypes = ["구해요 게시글 작성", "바꿔요 게시글 작성"] // 두 개의 항목을 리스트로 정의
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(sortTypes.indices, id: \.self) { index in
                        Button(action: {
                            if index == 0 {
                                isShowFind = true
                            } else {
                                isShowChange = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 17))
                                
                                Text(sortTypes[index])
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 8)
                                    .font(.system(size: 17))
                            }
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("닫기")
                                .foregroundStyle(.black)
                                .font(.system(size: 17))
                        }
                        Spacer()
                    }
                }
            }
            .scrollDisabled(true)
        }
        .fullScreenCover(isPresented: $isShowChange, onDismiss: {
            shouldShowActionSheet = false
        }, content: {
            ChangePostingView()
        })
        
        .fullScreenCover(isPresented: $isShowFind, onDismiss: {
            shouldShowActionSheet = false
        }, content: {
            FindPostingView()
        })
    }
}
