//
//  EmailCertiView.swift
//  BookBridge
//
//  Created by 이민호 on 1/30/24.
//

import SwiftUI

struct EmailCertiView: View {
    @StateObject var signUpVM = SignUpViewModel()
    @State var tag: Int? = nil
    
    var body: some View {
        NavigationView {
                        
            VStack {
                NavigationLink(destination: EmailSignUpView(signUpVM: self.signUpVM), tag: 1, selection: self.$tag) {}
                                    
                Image("Character")
                
                HStack {
                    Text("이메일로 \n가입할 수 있어요")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding()
                
                
                SignUpInputBoxView(signUpVM: signUpVM, inputer: SignUpInputer(input: .email))
                    .padding()
                
                if signUpVM.isCertiActive {
                    SignUpAuthCodeBoxView(signUpVm: signUpVM)
                        .padding()
                }
                                
                Spacer()
                
                Button {
                    signUpVM.isCertiCode()
                    
                    if let certiResult = signUpVM.isCertiClear {
                        switch certiResult {
                        case .right:
                            self.tag = 1
                        case .wrong:
                            print("잘못된 인증번호입니다. ")
                        case .timeOut:
                            signUpVM.isCertiClear = .wrong
                        }
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
}

#Preview {
    EmailCertiView()
}
