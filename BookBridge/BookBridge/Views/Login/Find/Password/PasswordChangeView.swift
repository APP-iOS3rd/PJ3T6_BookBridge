//
//  PasswordChangeView.swift
//  BookBridge
//
//  Created by 이민호 on 3/6/24.
//

import SwiftUI

struct PasswordChangeView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: SMSAuthViewModel
    @State var isLoading = false
    @State var showingAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 50)
            
            HStack {
                Text("새로운 비밀번호를 \n입력해주세요")
                    .font(.system(size: 30, weight: .semibold))
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 120)
            
            PasswordInputView(
                viewModel: viewModel,
                type: .password,
                title: "비밀번호",
                placeholder: "비밀번호를 입력해 주세요"
            )
                                                            
            Spacer()
                .frame(height: 20)
            
            PasswordInputView(
                viewModel: viewModel,
                type: .rePassword,
                title: "비밀번호 재입력",
                placeholder: "비밀번호를 재입력해 주세요"
            )
            
            Spacer()
            
            Button {
                viewModel.verifyPassword(isLoading: $isLoading, showingAlert: $showingAlert)
            } label: {
                HStack {
                    if isLoading {
                        LoadingCircle(size: 15, color: "FFFFFF")
                    }
                    
                    Text("확인")
                }
                .modifier(LargeBtnStyle())
            }
            
            Spacer()
                .frame(height: 20)
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("비밀번호 변경"),
                  message: Text("비밀번호가 변경되었습니다."),
                  primaryButton: .default(Text("확인"), action: {
                     pathModel.paths.removeSubrange(1...pathModel.paths.count-1)
                  }),
                  secondaryButton: .cancel())
        }
        
    }
}

#Preview {
    PasswordChangeView(viewModel: SMSAuthViewModel())
}
