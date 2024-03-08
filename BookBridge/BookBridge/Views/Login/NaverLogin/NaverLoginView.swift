//
//  NaverLoginView.swift
//  BookBridge
//
//  Created by 노주영 on 1/29/24.
//

import SwiftUI
import NaverThirdPartyLogin

struct NaverLoginView: View {
    @StateObject var naverLoginManger = NaverAuthManager.shared
    @Binding var showingLoginView: Bool
    
    var body: some View {
        VStack {
            Button{
                naverLoginManger.doNaverLogin()
            } label: {
                Image("naverLogo")
                    .resizable()
                    .frame(width: 36, height: 36)
            }
        }.onChange(of: naverLoginManger.isLogin) { _ in
            showingLoginView.toggle()            
        }
        .alert(isPresented: $naverLoginManger.showAlert) {
            Alert(
                title: Text("로그인 오류"), // Alert 제목
                message: Text(naverLoginManger.alertMessage),
                dismissButton: .default(Text("확인"))
            )
        }
        
        
    }
}

