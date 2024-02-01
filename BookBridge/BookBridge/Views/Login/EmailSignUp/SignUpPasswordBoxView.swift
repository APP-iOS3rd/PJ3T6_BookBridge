//
//  SignUpPasswordBox.swift
//  BookBridge
//
//  Created by 이민호 on 1/30/24.
//


import SwiftUI



struct SignUpPasswordBoxView: View {
    @StateObject var signUpVm: SignUpViewModel
    
    var body: some View {
        VStack {
            passwordView(text: "비밀번호", placeholder: "비밀번호를 입력해주세요", value: $signUpVm.password)
                .padding(.bottom, 20)
                
            
            passwordView(text: "비밀번호확인", placeholder: "비밀번호를 한번 더 입력해주세요", value: $signUpVm.passwordConfirm)
            
//            if let status = signUpVm.pwdStatus {
//                switch status {
//                case .wrong:
//                    StatusText(text: status.rawValue, color: "F80B0B")
//                case .invalid:
//                    StatusText(text: status.rawValue, color: "F80B0B")
//                case .none:
//                    StatusText(text: status.rawValue, color: "F80B0B")
//                }
//            }
            
        }
    }
    
    @ViewBuilder
    func passwordView(text: String, placeholder: String, value: Binding<String>) -> some View {
        VStack {
            HStack {
                Text(text)
                    .font(.system(size: 10))
                    .foregroundStyle(Color(hex: "999999"))
                
                Spacer()
            }
                        
            HStack {
                SecureField(placeholder, text: value)
                    .padding()
                    .foregroundColor(Color(hex: "3C3C43"))
                    .frame(height: 36)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F7F8FC"))
                    .cornerRadius(5.0)
            }
        }
    }
}

#Preview {
    SignUpPasswordBoxView(signUpVm: SignUpViewModel())
}
