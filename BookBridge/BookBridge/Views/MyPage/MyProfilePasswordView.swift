//
//  MyProfilePasswordView.swift
//  BookBridge
//
//  Created by 노주영 on 2/23/24.
//

import SwiftUI

struct MyProfilePasswordView: View {
    @Binding var isDuplication: Bool
    @Binding var isFalsePassword: Bool
    @Binding var isEditing: Bool
    @Binding var savePassword: String
    
    @StateObject var viewModel: MyProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("비밀번호")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 10)
            
            if isEditing {
                HStack(alignment: .bottom) {
                    TextField("영어, 숫자, 특수문자를 사용한 8~16글자", text: $viewModel.userPassword)
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.userPassword = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 17, weight: .medium))
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
            } else {
                HStack {
                    Text(viewModel.userPassword)
                        .font(.system(size: 17, weight: .medium))
                    
                    Spacer()
                }
                .frame(height: 30)
            }
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 2)
                .foregroundStyle(Color(hex: "D1D3D9"))
            
            HStack {
                if isFalsePassword {
                    Text("영어, 숫자, 특수문자를 조합해서 만들어주세요.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                Text("\(viewModel.userPassword.count)/15")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(hex: "767676"))
            }
            .padding(.top, 5)
        }
        .padding(.bottom, 20)
    }
}
