//
//  SignUpView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI

struct EmailSignUpView: View {
    @StateObject var signUpVM = SignUpVM()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Character")
                                                                                
                SignUpInputBox(signUpVM: signUpVM, inputer: SignUpInputer(input: .id))
                    .padding()
                
                SignUpInputBox(signUpVM: signUpVM, inputer: SignUpInputer(input: .nickName))
                    .padding()
                                                
                SignUpPasswordView(signUpVm: signUpVM)
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
            signUpVM.register {
                
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
    EmailSignUpView()
}
