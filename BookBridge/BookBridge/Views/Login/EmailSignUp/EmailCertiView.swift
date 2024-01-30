//
//  EmailCertiView.swift
//  BookBridge
//
//  Created by 이민호 on 1/30/24.
//

import SwiftUI

struct EmailCertiView: View {
    @StateObject var signUpVM = SignUpVM()
    @State var tag: Int? = nil
    
    var body: some View {
        NavigationView {
            
            
            VStack {
                NavigationLink(destination: EmailSignUpView(), tag: 1, selection: self.$tag) {
                    
                }
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
                
                if signUpVM.isCertiActive {
                    SignUpAuthCodeBox(signUpVm: signUpVM)
                        .padding()
                }
                                
                Spacer()
                
                Button {
                    self.tag = 1
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
