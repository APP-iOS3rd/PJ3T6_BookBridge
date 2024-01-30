//
//  ChangePasswordView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var isNavigationActive = false // 화면 전환 상태 관리
    var body: some View {
        VStack{
            Image("Character")
            
            NavigationLink(destination: LoginView(), isActive: $isNavigationActive) {
                EmptyView()
            }
            
            Button(action: {
                self.isNavigationActive = true // 버튼 클릭 시 화면 전환
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
