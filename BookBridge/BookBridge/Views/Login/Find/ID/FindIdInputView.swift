//
//  FindIdInputView.swift
//  BookBridge
//
//  Created by 이민호 on 3/7/24.
//

import SwiftUI

enum FindIdInputType {
    case phone
    case certificationNumber
}

struct FindIdInputView: View {
    @StateObject var viewModel: FindIdViewModel
    var type: FindIdInputType
    var placeholder: String
    
    var body: some View {
        VStack {
            switch type {
            case.phone:
                TextField(placeholder, text: $viewModel.phoneNumber)
                    .modifier(InputTextFieldStyle())
            case .certificationNumber:
                TextField(placeholder, text: $viewModel.certificationNumber)
                    .modifier(InputTextFieldStyle())
            }
            
            switch type {
            case .phone:
                StatusTextView(
                    text: viewModel.phoneNumberStatusText?.rawValue ?? "",
                    color: viewModel.phoneNumberStatusText?.getColor() ?? ""
                )
                
            case .certificationNumber:
                StatusTextView(
                    text: viewModel.certificationNumberStatusText?.rawValue ?? "",
                    color: viewModel.certificationNumberStatusText?.getColor() ?? ""
                )
            }
        }
    }
}

#Preview {
    FindIdInputView(
        viewModel: FindIdViewModel(),
        type: .phone,
        placeholder: "휴대폰번호 입력"
    )
}
