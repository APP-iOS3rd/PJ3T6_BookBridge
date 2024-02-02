//
//  SignUpInputView.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import SwiftUI

struct SignUpInputView: View {
    @StateObject var signUpVm: SignUpViewModel
    var manager: SignUpInputManager
        
    var body: some View {
        VStack {
            title()
                            
            switch manager.type {
            case .phone:
                inputField(text: $signUpVm.phoneNumer, placeholder: manager.placeholder)
                StatusTextView(text: signUpVm.phError?.rawValue ?? "", color: "F80B0B")
                
                
            case .pwd:
                pwdField(text: $signUpVm.password, placeholder: manager.placeholder)
                StatusTextView(text: signUpVm.pwdError?.rawValue ?? "", color: "F80B0B")
                
                                
            case .pwdConfirm:
                pwdField(text: $signUpVm.passwordConfirm, placeholder: manager.placeholder)
                StatusTextView(text: signUpVm.pwdConfirmError?.rawValue ?? "", color: "F80B0B")
                
            }
            
        }
    }
        
}

extension SignUpInputView {
    func title() -> some View {
        return
            HStack {
                Text(manager.title)
                    .font(.system(size: 10))
                    .foregroundStyle(Color(hex: "999999"))
                
                Spacer()
            }
    }
    
    func inputField(text: Binding<String>, placeholder: String) -> some View {
        return TextField(placeholder, text: text)
            .modifier(InputTextFieldStyle())
    }
    
    func pwdField(text: Binding<String>, placeholder: String) -> some View {
        return SecureField(placeholder, text: text)
            .modifier(InputTextFieldStyle())
    }
        
}

#Preview {
    SignUpInputView(signUpVm: SignUpViewModel(), manager: SignUpInputManager(input: .phone))
}
