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
    @FocusState var isFocused: Bool
    @State var isEamilCertified = false
    
    
    var body: some View {
        ZStack {
            
            ClearBackground(isFocused: $isFocused)
            
            VStack {
                Image("Character")
                
                HStack {
                    Text("이메일로 \n가입할 수 있어요")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding()
                
                
                SignUpInputBoxView(
                    signUpVM: signUpVM,
                    inputer: SignUpInputer(input: .email),
                    isFocused: $isFocused
                )
                .padding()
                
                if signUpVM.isEmailCertified {
                    SignUpAuthCodeBoxView(
                        signUpVm: signUpVM,
                        isFocused: $isFocused
                    )
                    .transition(.scale)
                    .padding()
                }
                
                                                                                            
                Spacer()
                
                if !isFocused {
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
                        Text("인증완료")
                            .modifier(LargeBtnStyle())
                    }
                    .padding()
                }
                                                
            }
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
