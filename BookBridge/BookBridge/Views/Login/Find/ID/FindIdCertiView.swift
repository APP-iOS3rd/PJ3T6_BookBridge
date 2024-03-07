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
    @State var isLoading = false
    @State var isComplete = false
    
    var body: some View {
        VStack(alignment: .leading) {
                        
            Text("\n인증번호를\n입력해주세요")
                .font(.system(size: 30, weight: .semibold))
            
            Spacer()
                .frame(height: 120)
            
            FindIdInputView(
                viewModel: viewModel,
                type: .certificationNumber,
                placeholder: "인증번호 입력"
            )
            
            Spacer()
            
            Button {
                // 1. 인증번호가 맞는지 확인
                // 2. 인증번호가 맞다면 FindIdResultView로 이동
                // 3. 인증번호 및 인증번호상태메세지 지우기
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
        .padding(.horizontal)
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
