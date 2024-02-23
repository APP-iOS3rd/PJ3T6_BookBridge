//
//  MyProfileNicknameView.swift
//  BookBridge
//
//  Created by 노주영 on 2/23/24.
//

import SwiftUI

struct MyProfileNicknameView: View {
    @Binding var isDuplication: Bool
    @Binding var isFalsePassword: Bool
    @Binding var isEditing: Bool
    @Binding var saveText: String
    
    @StateObject var viewModel: MyProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 10)
            
            if isEditing {
                HStack(alignment: .bottom) {
                    TextField("닉네임을 입력해주세요.", text: $viewModel.userNickname)
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.userNickname = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                .frame(height: 30)
                .onChange(of: viewModel.userNickname) { _ in
                    if viewModel.userNickname.count > 15 {
                        viewModel.userNickname = saveText
                    } else {
                        saveText = viewModel.userNickname
                    }
                }
            } else {
                HStack {
                    Text(viewModel.userNickname)
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
                if isDuplication {
                    Text("중복된 닉네임입니다.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                Text("\(viewModel.userNickname.count)/15")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(hex: "767676"))
            }
            .padding(.top, 5)
        }
        .padding(.bottom, 20)
    }
}
