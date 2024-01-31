//
//  SignUpInputView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI


struct SignUpInputBox: View {
    @StateObject var signUpVM: SignUpVM
    @State var status: Bool?
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
                case .id:
                    TextField(inputer.placeholder, text: $signUpVM.id)
                        .modifier(InputTextFieldStyle())
                case .nickName:
                    TextField(inputer.placeholder, text: $signUpVM.nickname)
                        .modifier(InputTextFieldStyle())
                }
                                                    
                Button {
                    switch inputer.type {
                    case .email:
                        if signUpVM.isValidEmail() {
                            status = true
                            signUpVM.sendMail()
                        } else {
                            status = false
                        }
                                                
                    case .id:
                        print("아이디 중복 확인 기능")
                    case .nickName:
                        print("닉네임 중복 확인 기능")
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
            
            if let status = status {
                if status {
                    StatusText(text: inputer.status[1], color: "0A84FF")
                } else {
                    StatusText(text: inputer.status[0], color: "F80B0B")
                }
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

#Preview {
    SignUpInputBox(signUpVM: SignUpVM(), inputer: SignUpInputer(input: .email))
}
