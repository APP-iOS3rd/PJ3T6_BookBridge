//
//  EmailCertiView.swift
//  BookBridge
//
//  Created by 이민호 on 1/30/24.
//

import SwiftUI

struct EmailCertiView: View {
    @StateObject var signUpVM = SignUpVM()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Character")
                
                HStack {
                    Text("이메일로 \n가입할 수 있어요")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding()
                
                
                SignUpInputBox(signUpVM: signUpVM, inputer: SignUpInputer(input: .email))
                    .padding()
                
                SignUpAuthCodeView(signUpVm: signUpVM)
                    .padding()
                
                Spacer()
                
                AuthConfirmBtn()
                    .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("회원가입")
                        .font(.headline)
                }
            }
        }
    }
    
    @ViewBuilder
    func AuthConfirmBtn() -> some View {
        Button {
            signUpVM.register {
                // 다음화면 이동 기능
            }
        } label: {
            Text("인증완료")
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "59AAE0"))
                .cornerRadius(10.0)
        }
    }
}

#Preview {
    EmailCertiView()
}
