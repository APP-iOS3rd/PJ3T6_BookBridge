//
//  SignUpView.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var signUpVM = SignUpVM()
    
    var body: some View {
        Text("회원가입")
        
        Spacer()
        
        SignUpInputEmailView(email: $signUpVM.email)
            .padding()
        
        SignUpAuthCodeView(signUpVm: signUpVM)
            .padding()
        
        SignUpPasswordView(signUpVm: signUpVM)
            .padding()
        
        Spacer()
        
        AuthConfirmBtn()
            .padding()
    }
    
    @ViewBuilder
    func AuthConfirmBtn() -> some View {
        Button {
            
        } label: {
            Text("회원가입")
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "59AAE0"))
                .cornerRadius(10.0)
        }
    }
}

#Preview {
    SignUpView()
}
