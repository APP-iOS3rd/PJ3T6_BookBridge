//
//  ChangePasswordView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @StateObject private var viewModel = ChangePasswordVM()
    
    var body: some View {
        VStack{
            Image("Character")
            
            VStack(alignment: .leading,spacing: 10){
                
                Spacer()
                    .frame(height: 80)
                
                Text("비밀번호 입력")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "999999"))
                
                TextField("새로운 비밀번호를 입력해 주세요", text: $viewModel.Resetpassword)
                    .padding()
                    .foregroundColor(Color(hex: "3C3C43"))
                    .frame(height: 36)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F7F8FC"))
                    .cornerRadius(5.0)
                
                Spacer()
                    .frame(height: 5)
                
                Text("비밀번호 재입력")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "999999"))
                
                TextField("새로운 비밀번호 한 번 더 입력해주세요", text: $viewModel.Resetpassword1)
                    .padding()
                    .foregroundColor(Color(hex: "3C3C43"))
                    .frame(height: 36)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F7F8FC"))
                    .cornerRadius(5.0)
                
                Text(viewModel.passwordErrorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 10))
                    .opacity(viewModel.passwordErrorMessage.isEmpty ? 0 : 1)
                
            }
            
            Spacer()
                .frame(height: 200)
            
            Button(action: {
                viewModel.Reset()
                if viewModel.passwordErrorMessage.isEmpty {
                    pathModel.paths.removeSubrange(1...pathModel.paths.count-1)
                }
                
                
            }, label: {
                Text("확인")
            })
            .foregroundColor(.white)
            .font(.system(size: 20).bold())
            .frame(width: 353, height: 50)
            .background(Color(hex: "59AAE0"))
            .cornerRadius(10)
        }
        .padding(20)
        .navigationBarTitle("비밀번호 변경", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
    }
}

#Preview {
    ChangePasswordView()
}
