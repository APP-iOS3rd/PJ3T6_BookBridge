//
//  FindPasswordInputView.swift
//  BookBridge
//
//  Created by 이민호 on 3/7/24.
//

import SwiftUI

struct FindPasswordInputView: View {
    @StateObject var viewModel: FindPasswordViewModel
    var isFocused: FocusState<Bool>.Binding
    var placeholder: String
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $viewModel.email)
                .focused(isFocused)
                .modifier(InputTextFieldStyle())
            
            StatusTextView(
                text: viewModel.emailStatusText?.rawValue ?? "",
                color: viewModel.emailStatusText?.getColor() ?? ""
            )
        }
        
    }
}

//#Preview {
//    FindPasswordInputView(
//        viewModel: FindPasswordViewModel(),
//        isFocused:
//        placeholder: "이메일을 입력해 주세요."
//    )
//}
