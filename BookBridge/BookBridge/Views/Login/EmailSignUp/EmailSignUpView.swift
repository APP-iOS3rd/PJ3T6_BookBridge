//
//  SignUpView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI

struct EmailSignUpView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @StateObject var signUpVM: SignUpViewModel
    private let format = FormatValidator()
    
    var body: some View {
        
            VStack {
                Image("Character")
                
                SignUpInputBoxView(signUpVM: signUpVM, inputer: SignUpInputer(input: .nickName))
                    .padding()
                
                SignUpInputView(signUpVm: signUpVM, manager: SignUpInputManager(input: .phone))
                    .padding()
                
                SignUpInputView(signUpVm: signUpVM, manager: SignUpInputManager(input: .pwd))
                    .padding()
                
                SignUpInputView(signUpVm: signUpVM, manager: SignUpInputManager(input: .pwdConfirm))
                    .padding()
                                                            
                Spacer()
                
                AuthConfirmBtn()
                    .padding()
            }
            .navigationBarTitle("회원가입", displayMode: .inline)
            .navigationBarItems(leading: CustomBackButtonView())        
    }
    
    @ViewBuilder
    func AuthConfirmBtn() -> some View {
        Button {
            signUpVM.signUp { success in
                if success {
                    pathModel.paths.removeAll()
                } else {
                    // 등록 실패 후의 작업 수행
                }
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
