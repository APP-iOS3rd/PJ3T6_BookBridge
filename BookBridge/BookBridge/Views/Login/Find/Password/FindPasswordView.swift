//
//  FindPasswordView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//

import SwiftUI

struct FindPasswordView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: FindPasswordViewModel
    @FocusState var isFocused: Bool
    @State private var isLoading = false
    @State private var isComplete = false

    var body: some View {
        ZStack {
            
            ClearBackground(isFocused: $isFocused)
            
            VStack(alignment: .leading) {
                
                Text("이메일을 알려주세요")
                    .foregroundStyle(.black)
                    .font(.system(size: 30, weight: .semibold))
                
                Spacer()
                    .frame(height: 8)
                
                Text("가입한 계정 이메일을 입력해주세요")
                    .foregroundStyle(Color(hex: "#848787"))
                    .font(.system(size: 15, weight: .regular))
                
                
                Spacer()
                    .frame(height: 80)
                
                FindPasswordInputView(
                    viewModel: viewModel,
                    isFocused: $isFocused,
                    placeholder: "이메일"
                )
                
                Spacer()
                
                if !isFocused { // 키보드가 보이지 않을 때만 확인 버튼 표시
                    Button {
                        viewModel.verifyEmail(
                            isLoading: $isLoading,
                            isComplete: $isComplete
                        )
                    } label: {
                        HStack {
                            if isLoading {
                                LoadingCircle(size: 15, color: "FFFFFF")
                            }
                            Text("확인")
                        }
                        .modifier(LargeBtnStyle())
                    }
                }
            }
        }
        .padding(20)
        .navigationBarTitle("비밀번호 찾기", displayMode: .inline)
        .onChange(of: isComplete) { _ in
            if isComplete {
                pathModel.paths.append(.resultPassword)
                isComplete = false
            }
        }        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.resetEmail()
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    FindPasswordView(viewModel: FindPasswordViewModel())
}
