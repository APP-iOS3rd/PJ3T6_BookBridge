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
    @FocusState var isFocused: Bool
    @State var isEamilCertified = false
    @State private var showingTermsSheet = false
    @State private var showAlert: Bool = false
    @State private var agreeToTerms: Bool = false
    @State private var isContinue : Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            ClearBackground(isFocused: $isFocused)
            
            VStack {
                Image("Character")
                
                HStack {
                    Text("이메일로 \n가입할 수 있어요")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding()
                
                
                SignUpInputBoxView(
                    signUpVM: signUpVM,
                    inputer: SignUpInputer(input: .email),
                    isFocused: $isFocused,
                    isContinue: $isContinue,
                    showingTermsSheet: $showingTermsSheet
                    
                )
                .padding()
                
                if signUpVM.isEmailCertified {
                    SignUpAuthCodeBoxView(
                        signUpVm: signUpVM,
                        isFocused: $isFocused
                    )
                    .transition(.scale)
                    .padding()
                }
                
                
                Spacer()
                
                if !isFocused {
                    Button {
                        signUpVM.validAuthCode() { success in
                            if success {
                                signUpVM.reset()
                                pathModel.paths.append(.signUp)
                            } else {
                                signUpVM.isEmailWrong = true
                            }
                        }
                    } label: {
                        Text("인증완료")
                            .modifier(LargeBtnStyle())
                    }
                    .padding()
                }
                
            }
        }
        .onAppear{
            showingTermsSheet = true
            signUpVM.isEmailCertified = false
            signUpVM.email = ""
            signUpVM.emailError = nil
        }
        .sheet(isPresented: $showingTermsSheet) {
            AgreeView(showAlert: $showAlert, agreeToTerms: $agreeToTerms, showingTermsSheet: $showingTermsSheet, isContinue: $isContinue)  // 이용약관 동의 여부에 따라 처리
                .presentationDetents([.medium])
                .cornerRadius(5)
                .presentationDragIndicator(.visible)
                .onDisappear{
                    if showAlert == true {
                        dismiss()
                    }
                }
                
                
        }
        .navigationBarTitle("회원가입", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
    }
}

//#Preview {
//    EmailCertiView(signUpVM: SignUpViewModel())
//}
// 이용약관 내용 및 동의 여부를 처리하는 View

