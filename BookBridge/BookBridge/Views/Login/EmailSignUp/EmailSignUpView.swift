//
//  SignUpView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI



struct EmailSignUpView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var signUpVM: SignUpViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            
            ClearBackground(isFocused: $isFocused)
            
            VStack {
                
                if !isFocused {
                    Image("Character")
                        .padding(.bottom, 30)
                }
                
                                                
                SignUpInputBoxView(
                    signUpVM: signUpVM,
                    inputer: SignUpInputer(input: .nickName),
                    isFocused: $isFocused
                )
                .padding(.bottom)
                    
                
                SignUpInputView(
                    signUpVm: signUpVM,
                    isFocused: $isFocused,
                    manager: SignUpInputManager(input: .phone)
                )
                .padding(.bottom)
                
                
                SignUpInputView(
                    signUpVm: signUpVM,
                    isFocused: $isFocused,
                    manager: SignUpInputManager(input: .pwd)
                )
                .padding(.bottom)
                
                SignUpInputView(
                    signUpVm: signUpVM,
                    isFocused: $isFocused,
                    manager: SignUpInputManager(input: .pwdConfirm)
                )
                .padding(.bottom)
                
                
                Spacer()
                
                
                if !isFocused {
                    AuthConfirmBtn()
                }
            }
        }
        .padding(.horizontal)
        .navigationBarTitle("회원가입", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    signUpVM.resetNickNamePhPWd()
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    @ViewBuilder
    func AuthConfirmBtn() -> some View {
        Button {
            signUpVM.signUp { success in
                if success {
                    pathModel.paths.removeSubrange(0...pathModel.paths.count-1)
                    signUpVM.resetNickNamePhPWd()
                } else {
                    print("등록 실패")
                }
            }
        } label: {
            Text("확인")
                .modifier(LargeBtnStyle())
            
        }
        
    }
}

#Preview {
    EmailSignUpView(signUpVM: SignUpViewModel())
}
