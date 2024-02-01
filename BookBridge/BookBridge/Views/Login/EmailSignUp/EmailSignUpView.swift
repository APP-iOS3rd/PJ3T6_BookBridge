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
                
                SignUpInputBoxView(signUpVM: signUpVM, inputer: SignUpInputer(input: .nickName), validator: Validator(signUpVM: signUpVM))
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
