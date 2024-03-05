//
//  FindPasswordView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//

import SwiftUI

struct FindPasswordView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @StateObject var viewModel = SMSAuthViewModel()
    @State private var isNavigationActive = false // 화면 전환 상태 관리
    
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
                    btnTitle: "인증확인"
                )
                
                
                
                Spacer()
                    
                
                
                

                
                Button {
                    
                } label: {
                    LargeBtnStyle(title: "확인")
                }
                                
            }
            
            
            
            
        }
        .padding(20)
        
        .navigationBarTitle("비밀번호 찾기", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        
    }
    
    
//    @ViewBuilder
//    func ResendBtn() -> some View {
//        Button {
//            viewModel.sendMail()
//        } label: {
//            Text("재전송")
//                .font(.system(size: 17))
//                .foregroundStyle(Color(hex: "59AAE0"))
//                .frame(width: 100, height: 36)
//                .border(Color(hex: "59AAE0"), width: 2)
//                .background(.white)
//                .cornerRadius(5.0)
//        }
//    }
    
    
}

#Preview {
    FindPasswordView()
}
