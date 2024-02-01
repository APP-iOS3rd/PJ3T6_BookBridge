//
//  SignUpInputView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI


enum NicknameError: String {
    case invalid = "잘못된 닉네임 형식입니다."
    case redundant = "이미 가입한 닉네임 입니다."
    case success = "사용가능한 닉네임 입니다."
}

enum EmailError: String {
    case invalid = "잘못된 이메일 형식입니다."
    case redundant = "이미 가입한 이메일 입니다."
    case success = "이메일 인증이 완료되었습니다."
}

struct SignUpInputBoxView: View {
    @StateObject var signUpVM: SignUpViewModel
    @State var status: Bool?
    var inputer: SignUpInputer
    var validator: Validator
    
    
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
                        validator.isValidEmail()
                                                                                                    
                    case .nickName:
                        validator.isValidNickname()
                    }
                } label: {
                    Text(inputer.btnTitle)
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                        .frame(width: 100, height: 36)
                        .background(Color(hex: "59AAE0"))
                        .cornerRadius(5.0)
                }
            }
            
            switch inputer.type {
            case .email:
                errorText(text: signUpVM.emailError?.rawValue ?? "", color: "F80B0B")
            
            case .nickName:
                errorText(text: signUpVM.nicknameError?.rawValue ?? "", color: "F80B0B")
            }
                                    
        }
    }
}

struct StatusText: View {
    var text: String
    var color: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: color))
            Spacer()
        }
    }
}

struct InputTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(Color(hex: "3C3C43"))
            .frame(height: 36)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "F7F8FC"))
            .cornerRadius(5.0)
    }
}

extension SignUpInputBoxView {
    func errorText(text: String, color: String) -> some View {
        return HStack {
            Text(text)
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: color))
            
            Spacer()
        }
    }
}

#Preview {
    SignUpInputBoxView(signUpVM: SignUpViewModel(), inputer: SignUpInputer(input: .email), validator: Validator(signUpVM: SignUpViewModel()))
}
