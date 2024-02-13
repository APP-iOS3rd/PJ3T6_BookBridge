//
//  SignUpInputView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI

struct SignUpInputBoxView: View {
    @StateObject var signUpVM: SignUpViewModel
    @State var isLoading = false
    var inputer: SignUpInputer
            
    var body: some View {
        VStack {
            HStack {
                Text(inputer.title)
                    .font(.system(size: 10))
                    .foregroundStyle(Color(hex: "999999"))
                                                
                Spacer()
            }
                        
            HStack {
                switch inputer.type {
                case .email:
                    TextField(inputer.placeholder, text: $signUpVM.email)
                        .modifier(InputTextFieldStyle())
               
                case .nickName:
                    TextField(inputer.placeholder, text: $signUpVM.nickname)
                        .modifier(InputTextFieldStyle())
                }
                                                    
                Button {
                    switch inputer.type {
                    case .email:
                        isLoading = true
                        signUpVM.validEmail() {
                            isLoading = false
                        }
    
                    case .nickName:
                        isLoading = true
                        signUpVM.validNickname() {
                            isLoading = false                            
                        }
                    }
                } label: {
                    HStack {
                        if isLoading {
                            LoadingCircle(size: 10, color: "FFFFFF")
                        }
                        
                        Text(inputer.btnTitle)
                    }
                    .modifier(MiddleBlueBtnStyle())
                }
            }
            
            switch inputer.type {
            case .email:
                StatusTextView(
                    text: signUpVM.emailError?.rawValue ?? "",
                    color: signUpVM.emailError?.getColor() ?? ""
                )
                            
            case .nickName:
                StatusTextView(
                    text: signUpVM.nicknameError?.rawValue ?? "",
                    color: signUpVM.nicknameError?.getColor() ?? ""
                )
            }
                                    
        }
    }
}

#Preview {
    SignUpInputBoxView(signUpVM: SignUpViewModel(), inputer: SignUpInputer(input: .email))
}
