//
//  ChangePasswordView.swift
//  BookBridge
//
//  Created by 이민호 on 3/11/24.
//

import SwiftUI

struct ChangePhoneNumberStandardView: View {
    @StateObject var viewModel: ChangePhonenumberViewModel
    @FocusState var isFocuced: Bool
    @Binding var showNextPage: Bool
    @Binding var showPhoneView: Bool
    
    var body: some View {
        ZStack {
            ClearBackground(isFocused: $isFocuced)
            
            VStack(alignment: .leading){
                
                switch viewModel.state {
                case .password:
                    Text("비밀번호 확인하기")
                        .font(.system(size: 30, weight: .semibold))
                case .phoneNumber:
                    Text("휴대폰번호 변경하기")
                        .font(.system(size: 30, weight: .semibold))
                case .certiNumber:
                    Text("인증번호 확인하기")
                        .font(.system(size: 30, weight: .semibold))
                }
                     
                
                Spacer()
                    .frame(height: 8)
                
                
                switch viewModel.state {
                case .password:
                    Text("휴대폰번호 변경을 위해 비밀번호를 입력해 주세요")
                        .foregroundStyle(Color(hex: "#848787"))
                        .font(.system(size: 15, weight: .regular))
                case .phoneNumber:
                    Text("새로운 휴대폰번호를 입력해주세요")
                        .foregroundStyle(Color(hex: "#848787"))
                        .font(.system(size: 15, weight: .regular))
                case .certiNumber:
                    Text("휴대폰으로 전송된 인증번호를 입력해주세요")
                        .foregroundStyle(Color(hex: "#848787"))
                        .font(.system(size: 15, weight: .regular))
                }
                            
                
                Spacer()
                    .frame(height: 120)
                
                
                VStack {
                    switch viewModel.state {
                    case .password:
                        SecureField("비밀번호를 입력해주세요", text: $viewModel.state.text)
                            .keyboardType(.default)
                            .focused($isFocuced)
                            .textFieldStyle(.roundedBorder)                            
                    case .phoneNumber:
                        TextField("휴대폰번호를 입력해주세요", text: $viewModel.state.text)
                            .keyboardType(.numberPad)
                            .focused($isFocuced)
                            .textFieldStyle(.roundedBorder)
                    case .certiNumber:
                        TextField("인증번호를 입력해주세요", text: $viewModel.state.text)
                            .keyboardType(.numberPad)
                            .focused($isFocuced)
                            .textFieldStyle(.roundedBorder)
                    }
                                                                    
                    switch viewModel.error {
                    case let .password(string):
                        StatusTextView(
                            text: string,
                            color: "F80B0B"
                        )
                    case let .phoneNumber(string):
                        StatusTextView(
                            text: string,
                            color: "F80B0B"
                        )
                    case let .certiNumber(string):
                        StatusTextView(
                            text: string,
                            color: "F80B0B"
                        )
                    }
                }
                
                
                Spacer()
                    
                if !isFocuced {
                    Button {
                        switch viewModel.state {
                        case .password:
                            viewModel.action(.checkPassword)
                        case .phoneNumber:
                            viewModel.action(.changePhoneNumber)
                        case .certiNumber:
                            viewModel.action(.confirmVerificationNumber)
                        }                    
                    } label: {
                        HStack {          
                            if viewModel.complete == .loading {
                                LoadingCircle(size: 20, color: "FFFFFF")
                            }                            
                            Text("확인")
                        }
                        .modifier(LargeBtnStyle())
                    }
                }
            }
        }        
        .padding(.horizontal)        
        .onChange(of: viewModel.complete) { complete in
            switch viewModel.state {
            case .password:
                if viewModel.complete == .success {
                    showNextPage = true
                }
            case .phoneNumber:
                if viewModel.complete == .success {
                    showNextPage = true
                }
            case .certiNumber:
                if viewModel.complete == .success {
                    showPhoneView = false
                }
            }
        }
    }
}
