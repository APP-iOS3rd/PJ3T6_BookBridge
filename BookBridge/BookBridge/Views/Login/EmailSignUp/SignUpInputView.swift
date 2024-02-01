//
//  SignUpInputView.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import SwiftUI

enum SignUpInputType {
    case phone
    case pwd
    case pwdConfirm
}

enum PhoneError: String {
    case invalid = "휴대폰 번호가 올바르지 않습니다."
    case empty = "휴대폰 번호가 입력되지 않았습니다."
    case none = ""
}

enum PwdError: String {
    case empty = "비밀번호가 입력되지 않았습니다."
    case none = ""
}

enum PwdConfirmError: String {
    case wrong = "비밀번호가 서로 일치하지 않습니다."
    case invalid = "비밀번호를 영어, 숫자, 특수문자를 사용하여 8~16글자 로 작성해주세요"
    case empty = "비밀번호 확인이 입력되지 않았습니다."
    case none = ""
}

struct SignUpInputView: View {
    @StateObject var signUpVm: SignUpViewModel
    var manager: SignUpInputManager
        
    var body: some View {
        VStack {
            title()
                            
            switch manager.type {
            case .phone:
                inputField(text: $signUpVm.phoneNumer, placeholder: manager.placeholder)
                errorText(text: signUpVm.phError?.rawValue ?? "")
                
            case .pwd:
                pwdField(text: $signUpVm.password, placeholder: manager.placeholder)
                errorText(text: signUpVm.pwdError?.rawValue ?? "")
                                
            case .pwdConfirm:
                pwdField(text: $signUpVm.passwordConfirm, placeholder: manager.placeholder)
                errorText(text: signUpVm.pwdConfirmError?.rawValue ?? "")
                
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
            .padding()
            .foregroundColor(Color(hex: "3C3C43"))
            .frame(height: 36)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "F7F8FC"))
            .cornerRadius(5.0)
    }
    
    func pwdField(text: Binding<String>, placeholder: String) -> some View {
        return SecureField(placeholder, text: text)
            .padding()
            .foregroundColor(Color(hex: "3C3C43"))
            .frame(height: 36)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "F7F8FC"))
            .cornerRadius(5.0)
    }
    
    func errorText(text: String) -> some View {
        return HStack {
            Text(text)
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: "F80B0B"))
            
            Spacer()
        }
    }
}

#Preview {
    SignUpInputView(signUpVm: SignUpViewModel(), manager: SignUpInputManager(input: .phone))
}
