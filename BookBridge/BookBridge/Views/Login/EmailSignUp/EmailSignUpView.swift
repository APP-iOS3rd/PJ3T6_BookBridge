//
//  SignUpView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI

struct EmailSignUpView: View {
    @StateObject var signUpVM: SignUpViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Character")
                                                                                
                SignUpInputBoxView(signUpVM: signUpVM, inputer: SignUpInputer(input: .id))
                    .padding()
                
                SignUpInputBoxView(signUpVM: signUpVM, inputer: SignUpInputer(input: .nickName))
                    .padding()
                                                
                SignUpPasswordBoxView(signUpVm: signUpVM)
                    .padding()
                
                Spacer()
                
                AuthConfirmBtn()
                    .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("회원가입")
                        .font(.headline)
                }
            }
        }
    }
    
    @ViewBuilder
    func AuthConfirmBtn() -> some View {
        Button {
            signUpVM.isValidPwd()
                        
            if signUpVM.pwdStatus == PwdError.none && signUpVM.validAll() {
                signUpVM.userSave()
            }
        } label: {
            Text("확인")
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "59AAE0"))
                .cornerRadius(10.0)
        }
    }
}

#Preview {
    EmailSignUpView(signUpVM: SignUpViewModel())
}
