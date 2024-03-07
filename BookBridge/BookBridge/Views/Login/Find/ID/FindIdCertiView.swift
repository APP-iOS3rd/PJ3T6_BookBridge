//
//  FindIdCertiView.swift
//  BookBridge
//
//  Created by 이민호 on 3/7/24.
//

import SwiftUI

struct FindIdCertiView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: FindIdViewModel
    @FocusState var isFocused: Bool
    @State var isLoading = false
    @State var isComplete = false
    
    var body: some View {
        VStack(alignment: .leading) {
                        
            Text("인증번호를 알려주세요")
                .font(.system(size: 30, weight: .semibold))
            
            Spacer()
                .frame(height: 8)
            
            Text("휴대폰으로 전송된 인증번호를 입력해주세요")
                .foregroundStyle(Color(hex: "#848787"))
                .font(.system(size: 15, weight: .regular))
            
            Spacer()
                .frame(height: 80)
            
            FindIdInputView(
                viewModel: viewModel,
                isFocused: $isFocused,
                type: .certificationNumber,
                placeholder: "인증번호 입력"
            )
            
            Spacer()
            
            if !isFocused {
                Button {
                    viewModel.verifyCertificationNumber(
                        isLoading: $isLoading,
                        isComplete: $isComplete
                    )
                } label: {
                    HStack {
                        if isLoading {
                            LoadingCircle(size: 20, color: "FFFFFF")
                        }
                        Text("확인")
                    }
                    .modifier(LargeBtnStyle())
                }
            }
        }
        .padding(.horizontal)
        .onAppear (perform : UIApplication.shared.hideKeyboard)
        .onChange(of: isComplete) { _ in
            if self.isComplete {
                pathModel.paths.append(.resultId)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.resetCertificationNumber()
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
    FindIdCertiView(viewModel: FindIdViewModel())
}
