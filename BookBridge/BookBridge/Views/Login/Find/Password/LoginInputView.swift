//
//  LoginInputView.swift
//  BookBridge
//
//  Created by 이민호 on 3/5/24.
//

import SwiftUI

enum LoginInputType {
    case email
    case phone
    case cerificationNumber
}

struct LoginInputView: View {
    @StateObject var viewModel: SMSAuthViewModel
    @State var isShowingStatusText = false
    @State var isLoading = false
    var type: LoginInputType
    var title: String
    var placeholder: String
    var btnTitle: String
    
    var body: some View {
        VStack(alignment: .leading) {            
            
            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(hex: "999999"))
                
                                                    
            HStack {
                switch type {
                case .email:
                    TextField(placeholder, text: $viewModel.email)
                        .modifier(InputTextFieldStyle())
                case .phone:
                    TextField(placeholder, text: $viewModel.phoneNumber)
                        .modifier(InputTextFieldStyle())
                case .cerificationNumber:
                    TextField(placeholder, text: $viewModel.certificationNum)
                        .modifier(InputTextFieldStyle())
                }
                
                 
                HStack {
                    Button {
                        switch type {
                        case .email:
                            viewModel.verifyEmail(isLoading: $isLoading)
                        case .phone:
                            viewModel.verifyPhoneNumber(isLoading: $isLoading)
                        case .cerificationNumber:
                            viewModel.verifyPhoneNumber(isLoading: $isLoading)
                        }
                        
                    } label: {
                        switch type {
                        case .email:
                            HStack {
                                if isLoading {
                                    LoadingCircle(size: 10, color: "FFFFFF")
                                }
                                Text(btnTitle)
                            }
                            .modifier(MiddleBlueBtnStyle())
                        case .cerificationNumber:
                            HStack {
                                if isLoading {
                                    LoadingCircle(size: 10, color: "59AAE0")
                                }
                                Text(btnTitle)
                            }
                            .modifier(MiddleWhiteBtnStyle())
                        case .phone:
                            Text("")
                        }
                    }
                }
            }
            
            
            switch type {
            case .email:
                StatusTextView(
                    text: viewModel.emailStatusText?.rawValue ?? "",
                    color: viewModel.emailStatusText?.getColor() ?? ""
                )
            case .phone:
                StatusTextView(
                    text: viewModel.phoneNumberStatusText?.rawValue ?? "",
                    color: viewModel.phoneNumberStatusText?.getColor() ?? ""
                )
            case .cerificationNumber:
                StatusTextView(
                    text: viewModel.certificationNumStatusText?.rawValue ?? "",
                    color: viewModel.certificationNumStatusText?.getColor() ?? ""
                )
            }
        }
    }
}

#Preview {
    LoginInputView(
        viewModel: SMSAuthViewModel(),
        type: .email,
        title: "이메일",
        placeholder: "이메일을 입력해 주세요",
        btnTitle: "확인하기"
    )
}
