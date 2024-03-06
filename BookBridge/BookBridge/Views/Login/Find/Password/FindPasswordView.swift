//
//  FindPasswordView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//

import SwiftUI

struct FindPasswordView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @StateObject var viewModel: SMSAuthViewModel
    @State private var isNavigationActive = false // 화면 전환 상태 관리
    @State var isLoading = false
    @State var isComplete = false
    
    var body: some View {
        
        
        VStack {
            
            Image("Character")
            
            
            VStack(alignment: .leading,spacing: 5 ) {
                
                Text("가입할 때 입력한 이메일과 \n휴대폰번호를 입력해주세요")
                    .font(.system(size: 20, weight: .regular))
                                
                
                Spacer()
                    .frame(height: 50)
                
                
                LoginInputView(
                    viewModel: viewModel,
                    type: .email,
                    title: "이메일",
                    placeholder: "이메일을 입력해주세요",
                    btnTitle: "확인하기"
                )
                
                
                Spacer()
                    .frame(height: 5)
                
                
                LoginInputView(
                    viewModel: viewModel,
                    type: .phone,
                    title: "휴대폰번호",
                    placeholder: "휴대폰번호를 입력해주세요",
                    btnTitle: "인증하기"
                )
                
                
                Spacer()
                    .frame(height: 5)
                
                
                LoginInputView(
                    viewModel: viewModel,
                    type: .cerificationNumber,
                    title: "인증번호",
                    placeholder: "인증번호를 입력해주세요",
                    btnTitle: "재전송"
                )
                
                
                
                Spacer()
                    
                
        
                Button {
//                    isComplete = true
//                    if isComplete {
//                        pathModel.paths.append(.changepassword)
//                    }
                    
                    if viewModel.verifyAll() {
                        viewModel.verifyCertificationNumber(
                            isLoading: $isLoading,
                            isComplete: $isComplete
                        )                                                
                    }                                        
                } label: {
                    HStack {
                        if isLoading {
                            LoadingCircle(size: 15, color: "FFFFFF")
                        }
                        Text("확인")
                    }
                    .modifier(LargeBtnStyle())
                }
                                
            }
        }
        .padding(20)
        .navigationBarTitle("비밀번호 찾기", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        .onChange(of: isComplete) { isComplete in
            if isComplete {
                print("휴대폰 인증 완료!")
                pathModel.paths.append(.changepassword)
            }
        }
        
    }
    
}

//#Preview {
//    FindPasswordView()
//}
