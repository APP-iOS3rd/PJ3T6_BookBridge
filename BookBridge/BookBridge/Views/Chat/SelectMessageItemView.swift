//
//  SelectMessageItemView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/04/04.
//

import SwiftUI

struct SelectMessageItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var shouldShowActionSheet: Bool
    @Binding var showToast: Bool
    @Binding var message: String
    
    let sortTypes = ["복사하기"] // 항목을 리스트로 정의
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(sortTypes.indices, id: \.self) { index in
                        Button(action: {
                            if index == 0 {
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                                shouldShowActionSheet = false
                                UIPasteboard.general.string = message
                            }
                        }) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 17))
                                
                                Text(sortTypes[index])
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 8)
                                    .font(.system(size: 17))
                            }
                        }
                        .overlay(
                            ToastMessageView(isShowing: $showToast)
                                .zIndex(1),
                            alignment: .bottom
                        )
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
    }
}
