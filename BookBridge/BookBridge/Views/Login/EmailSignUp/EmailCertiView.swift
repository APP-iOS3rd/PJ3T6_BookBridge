//
//  EmailCertiView.swift
//  BookBridge
//
//  Created by 이민호 on 1/30/24.
//

import SwiftUI

struct EmailCertiView: View {
    @StateObject var signUpVM: SignUpViewModel
    @EnvironmentObject private var pathModel: PathViewModel
    @State var isEamilCertified = false
    
    var body: some View {
        VStack {
            Image("Character")
            
            HStack {
                Text("이메일로 \n가입할 수 있어요")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding()
            
            
            SignUpInputBoxView(signUpVM: signUpVM, inputer: SignUpInputer(input: .email))
                .padding()
            
            if signUpVM.isEmailCertified {
                SignUpAuthCodeBoxView(signUpVm: signUpVM)
                    .transition(.scale)
                    .padding()
            }
            
//            if let certiActive = signUpVM.isCertiActive, certiActive {
//                SignUpAuthCodeBoxView(signUpVm: signUpVM)
//                    .padding()
//
//            }
                                                                                        
            Spacer()
            
            Button {
                signUpVM.validAuthCode() { success in
                    if success {
                        signUpVM.reset()
                        pathModel.paths.append(.signUp)
                    } else {
                        signUpVM.isEmailWrong = true
                    }
                }                                                
            } label: {
                LargeBtnStyle(title: "인증완료")
            }
            .padding()
                                            
        }
        .onAppear{
            
            signUpVM.isEmailCertified = false
            signUpVM.email = ""
            signUpVM.emailError = nil
        }
        .navigationBarTitle("회원가입", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
    }
}

//#Preview {
//    EmailCertiView(signUpVM: SignUpViewModel())
//}
