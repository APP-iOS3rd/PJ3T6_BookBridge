//
//  SignUpInputView.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import SwiftUI

struct SignUpInputView: View {
    @StateObject var signUpVm: SignUpViewModel
    var isFocused: FocusState<Bool>.Binding
    var manager: SignUpInputManager
        
    var body: some View {
        VStack {
            title()
                            
            switch manager.type {
            case .phone:
                TextField(manager.placeholder, text: $signUpVm.phoneNumer)
                    .keyboardType(.numberPad)
                    .focused(isFocused)
                    .modifier(InputTextFieldStyle())
                
                StatusTextView(text: signUpVm.phError?.rawValue ?? "", color: "F80B0B")
                                
            case .pwd:
                SecureField(manager.placeholder, text: $signUpVm.password)
                    .keyboardType(.default)
                    .focused(isFocused)
                    .modifier(InputTextFieldStyle())
                
                StatusTextView(text: signUpVm.pwdError?.rawValue ?? "", color: "F80B0B")
                
                                
            case .pwdConfirm:
                SecureField(manager.placeholder, text: $signUpVm.passwordConfirm)
                    .keyboardType(.default)
                    .focused(isFocused)
                    .modifier(InputTextFieldStyle())
                                
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
}

//#Preview {
//    SignUpInputView(
//        signUpVm: SignUpViewModel(),
//        manager: SignUpInputManager(input: .phone)
//    )
//}
