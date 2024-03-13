//
//  MyProfilePasswordView.swift
//  BookBridge
//
//  Created by 노주영 on 2/23/24.
//

import SwiftUI

struct MyProfilePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = MyProfilePasswordViewModel()
    
    @State private var isFalsePassword: Bool = false
    @State private var isFalseNewPassword: Bool = false
    @State private var isReTryPLogin: Bool = false
    @State private var savePassword: String = ""
    @State private var saveNewPassword: String = ""
    @State private var saveReNewPassword: String = ""
    
    @FocusState var isShowKeyboard: Bool
    
    var body: some View {
        ZStack {
            ClearBackground(
                isFocused: $isShowKeyboard
            )
            
            VStack(alignment: .leading) {
                Text("현재 비밀번호")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.bottom, 10)
                
                HStack(alignment: .bottom) {
                    SecureField("현재 비밀번호를 입력해주세요", text: $viewModel.userPassword)
                        .font(.system(size: 15, weight: .medium))
                        .focused($isShowKeyboard)
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.userPassword = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                .frame(height: 30)
                .onChange(of: viewModel.userPassword) { _ in
                    if viewModel.userPassword.count > 15 {
                        viewModel.userPassword = savePassword
                    } else {
                        savePassword = viewModel.userPassword
                    }
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 2)
                    .foregroundStyle(Color(hex: "D1D3D9"))
                
                HStack {
                    if isFalsePassword {
                        Text("현재 비밀번호가 일치하지 않습니다.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.red)
                    }
                    
                    if isReTryPLogin {
                        Text("다시 로그인 후 시도해주세요")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.red)
                    }
                    
                    Spacer()
                    
                    Text("\(viewModel.userPassword.count)/15")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "767676"))
                }
                .padding(.top, 5)
                .padding(.bottom, 15)
                
                Text("새 비밀번호")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.bottom, 10)
                
                HStack(alignment: .bottom) {
                    SecureField("영어, 숫자, 특수문자를 사용한 8~16글자", text: $viewModel.newPassword)
                        .font(.system(size: 15, weight: .medium))
                        .focused($isShowKeyboard)
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.newPassword = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                .frame(height: 30)
                .onChange(of: viewModel.newPassword) { _ in
                    if viewModel.newPassword.count > 15 {
                        viewModel.newPassword = saveNewPassword
                    } else {
                        saveNewPassword = viewModel.newPassword
                    }
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 2)
                    .foregroundStyle(Color(hex: "D1D3D9"))
                
                HStack {
                    if isFalseNewPassword {
                        Text("영어, 숫자, 특수문자를 조합해서 만들어주세요.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.red)
                    }
                    
                    Spacer()
                    
                    Text("\(viewModel.newPassword.count)/15")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "767676"))
                }
                .padding(.top, 5)
                .padding(.bottom, 15)
                
                Text("새 비밀번호 재입력")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.bottom, 10)
                
                HStack(alignment: .bottom) {
                    SecureField("새 비밀번호를 재입력 해주세요", text: $viewModel.reNewPassword)
                        .font(.system(size: 15, weight: .medium))
                        .focused($isShowKeyboard)
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.reNewPassword = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                .frame(height: 30)
                .onChange(of: viewModel.reNewPassword) { _ in
                    if viewModel.reNewPassword.count > 15 {
                        viewModel.reNewPassword = saveReNewPassword
                    } else {
                        saveReNewPassword = viewModel.reNewPassword
                    }
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 2)
                    .foregroundStyle(Color(hex: "D1D3D9"))
                
                HStack {
                    Spacer()
                    
                    Text("\(viewModel.reNewPassword.count)/15")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(hex: "767676"))
                }
                .padding(.top, 5)
                .padding(.bottom, 30)
                
                if viewModel.newPassword == viewModel.reNewPassword && viewModel.newPassword != "" && viewModel.reNewPassword != "" {
                    Button {
                        viewModel.doEditing(password: UserManager.shared.user?.password ?? "") { noComplete in
                            if noComplete.1 {
                                isReTryPLogin = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    isReTryPLogin = false
                                }
                            } else {
                                if noComplete.0 == nil {
                                    isFalsePassword = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        isFalsePassword = false
                                    }
                                } else {
                                    if noComplete.0 ?? true {
                                        isFalseNewPassword = true
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            isFalseNewPassword = false
                                        }
                                    } else {
                                        viewModel.userManager.user?.password = viewModel.newPassword
                                        
                                        viewModel.userPassword = ""
                                        viewModel.newPassword = ""
                                        viewModel.reNewPassword = ""
                                        
                                        savePassword = ""
                                        saveNewPassword = ""
                                        saveReNewPassword = ""
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("비밀번호 변경")
                            .font(.system(size: 17))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(hex: "59AAE0"))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden()
        .navigationTitle("비밀번호 변경")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
                isShowKeyboard = false
            }
        }
    }
}
