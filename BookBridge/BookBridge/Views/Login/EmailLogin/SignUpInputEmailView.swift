//
//  SignUpInputView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI

struct SignUpInputEmailView: View {
    @StateObject var signUpVM: SignUpVM
    
    var body: some View {
        VStack {
            HStack {
                Text("이메일")
                    .font(.system(size: 10))
                    .foregroundStyle(Color(hex: "999999"))
                
                Spacer()
            }
                        
            HStack {
                TextField("이메일을 입력해 주세요", text: $signUpVM.email)
                    .padding()
                    .foregroundColor(Color(hex: "3C3C43"))
                    .frame(height: 36)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F7F8FC"))
                    .cornerRadius(5.0)
                
                Button {
                    signUpVM.sendMail()
                    print("메일을 전송하였습니다.")
                } label: {
                    Text("인증하기")
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                        .frame(width: 100, height: 36)
                        .background(Color(hex: "59AAE0"))
                        .cornerRadius(5.0)
                }
            }
        }
    }
}

#Preview {
    SignUpInputEmailView(signUpVM: SignUpVM())
}
