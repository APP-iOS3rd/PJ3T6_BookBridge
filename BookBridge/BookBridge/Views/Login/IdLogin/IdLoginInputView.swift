//
//  IdLoginInputView.swift
//  BookBridge
//
//  Created by 이민호 on 3/8/24.
//

import SwiftUI

enum IdLoginInputType {
    case id
    case password
}

struct IdLoginInputView: View {
    @StateObject var viewModel: IdLoginViewModel
    var isFocused: FocusState<Bool>.Binding
    var type: IdLoginInputType
    var placeholder: String
    
    
    var body: some View {
        VStack {
            switch type {
            case .id:
                TextField(placeholder, text: $viewModel.username)
                    .keyboardType(.default)
                    .focused(isFocused)
                    .modifier(InputTextFieldStyle())
            case .password:
                SecureField(placeholder, text: $viewModel.password)
                    .keyboardType(.default)
                    .focused(isFocused)
                    .modifier(InputTextFieldStyle())
            }
            
            switch type {
            case .id:
                StatusTextView(
                    text: viewModel.usernameErrorMessage,
                    color: "F80B0B"
                )
            case .password:
                StatusTextView(
                    text: viewModel.passwordErrorMessage,
                    color: "F80B0B"
                )
            }
        }
    }
}

//#Preview {
//    IdLoginInputView(
//        viewModel: IdLoginViewModel(),
//        // isFocused:
//        type: .id,
//        placeholder: "아이디를 입력하세요"
//    )
//}
