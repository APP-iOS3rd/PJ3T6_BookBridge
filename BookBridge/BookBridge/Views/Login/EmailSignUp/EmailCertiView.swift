//
//  EmailCertiView.swift
//  BookBridge
//
//  Created by 이민호 on 1/30/24.
//

import SwiftUI

struct EmailCertiView: View {
    @StateObject var signUpVM: SignUpViewModel
    @EnvironmentObject private var pathModel: PathViewModel
    @State var tag: Int? = nil
    
    var body: some View {
        VStack {
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
                        signUpVM.reset()
                        pathModel.paths.append(.signUp)
                    case .wrong:
                        print("잘못된 인증번호입니다.")
                    case .timeOut:
                        signUpVM.isCertiClear = .wrong
                    }
                }
            } label: {
                LargeBtnStyle(title: "인증완료")
            }
            .padding()
                                            
        }
        .navigationBarTitle("회원가입", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        
    }
    
}

#Preview {
    EmailCertiView(signUpVM: SignUpViewModel())
}
