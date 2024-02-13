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
    
    var body: some View {
        
            VStack {
                Image("Character")
                    .padding(.bottom, 30)
                                                
                SignUpInputBoxView(signUpVM: signUpVM, inputer: SignUpInputer(input: .nickName))
                        .padding(.bottom)
                    
                SignUpInputView(signUpVm: signUpVM, manager: SignUpInputManager(input: .phone))
                    .padding(.bottom)
                
                SignUpInputView(signUpVm: signUpVM, manager: SignUpInputManager(input: .pwd))
                    .padding(.bottom)
                
                SignUpInputView(signUpVm: signUpVM, manager: SignUpInputManager(input: .pwdConfirm))
                    .padding(.bottom)
                                                                                                    
                Spacer()
                
                AuthConfirmBtn()
            }
            .padding(.horizontal)
            .navigationBarTitle("회원가입", displayMode: .inline)
            .navigationBarItems(leading: CustomBackButtonView())        
    }
    
    @ViewBuilder
    func AuthConfirmBtn() -> some View {
        Button {
            signUpVM.signUp { success in
                if success {
                    pathModel.paths.removeSubrange(0...pathModel.paths.count-1)
                } else {
                    print("등록 실패")
                }
            }
        } label: {
            LargeBtnStyle(title: "확인")
        }
        
    }
}

#Preview {
    EmailSignUpView(signUpVM: SignUpViewModel())
}
