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
    @StateObject var findIdVM: FindIdViewModel
    var isFocused: FocusState<Bool>.Binding
    var type: FindIdInputType
    var placeholder: String

    
    var body: some View {
        VStack {
            switch type {
            case.phone:
                TextField(placeholder, text: $findIdVM.phoneNumber)
                    .keyboardType(.numberPad)
                    .focused(isFocused)
                    .modifier(InputTextFieldStyle())
            case .certificationNumber:
                TextField(placeholder, text: $findIdVM.certificationNumber)
                    .keyboardType(.numberPad)
                    .focused(isFocused)
                    .modifier(InputTextFieldStyle())
                    
            }
            
            switch type {
            case .phone:
                StatusTextView(
                    text: findIdVM.phoneNumberStatusText?.rawValue ?? "",
                    color: findIdVM.phoneNumberStatusText?.getColor() ?? ""
                )
                
            case .certificationNumber:
                StatusTextView(
                    text: findIdVM.certificationNumberStatusText?.rawValue ?? "",
                    color: findIdVM.certificationNumberStatusText?.getColor() ?? ""
                )
            }
        }
    }
}

//#Preview {
//    FindIdInputView(
//        viewModel: FindIdViewModel(),
//        type: .phone,
//        placeholder: "휴대폰번호 입력"
//    )
//}
