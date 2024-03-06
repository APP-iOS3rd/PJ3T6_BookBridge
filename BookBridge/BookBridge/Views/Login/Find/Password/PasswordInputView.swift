//
//  PasswordInputView.swift
//  BookBridge
//
//  Created by 이민호 on 3/6/24.
//

import SwiftUI

enum PasswordInputType {
    case password
    case rePassword
}

struct PasswordInputView: View {
    @StateObject var viewModel: SMSAuthViewModel
    var type: PasswordInputType
    var title: String
    var placeholder: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(hex: "999999"))
            
            switch type {
            case .password:
                TextField(placeholder, text: $viewModel.password)
                    .modifier(InputTextFieldStyle())
            case .rePassword:
                TextField(placeholder, text: $viewModel.rePassword)
                    .modifier(InputTextFieldStyle())
            }
            
            switch type {
            case .password:
                StatusTextView(
                    text: viewModel.passwordStatusText?.rawValue ?? "",
                    color: "F80B0B"
                )
            case .rePassword:
                StatusTextView(
                    text: viewModel.rePasswordStatusText?.rawValue ?? "",
                    color: "F80B0B"
                )
            }
            
        }
    }
}

#Preview {
    PasswordInputView(
        viewModel: SMSAuthViewModel(),
        type: .password,
        title: "비밀번호",
        placeholder: "비밀번호를 입력해주세요"
    )
}
