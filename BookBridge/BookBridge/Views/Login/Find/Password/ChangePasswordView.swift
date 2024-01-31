//
//  ChangePasswordView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var viewModel = ChangePasswordVM()
    
    var body: some View {
        VStack{
            Image("Character")
            
            Text("비밀번호 입력")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(hex: "999999"))
            
            TextField("아이디를 입력해주세요", text: $viewModel.email)
                .padding()
                .foregroundColor(Color(hex: "3C3C43"))
                .frame(height: 36)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "F7F8FC"))
                .cornerRadius(5.0)
            
            Text("새로운 비밀번호 입력")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(hex: "999999"))
            
            TextField("아이디를 입력해주세요", text: $viewModel.email)
                .padding()
                .foregroundColor(Color(hex: "3C3C43"))
                .frame(height: 36)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "F7F8FC"))
                .cornerRadius(5.0)
            
            Button(action: {
                pathModel.paths.removeSubrange(1...pathModel.paths.count-1)
            }, label: {
                Text("확인")
            })
            .foregroundColor(.white)
            .font(.system(size: 20).bold())
            .frame(width: 353, height: 50) // 여기에 프레임을 설정
            .background(Color(hex: "59AAE0"))
            .cornerRadius(10)
        }
        .navigationBarTitle("비밀번호 변경", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
    }
}

#Preview {
    ChangePasswordView()
}
