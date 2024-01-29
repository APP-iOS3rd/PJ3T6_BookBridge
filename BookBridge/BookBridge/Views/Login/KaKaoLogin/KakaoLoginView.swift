//
//  KakaoLoginView.swift
//  BookBridge
//
//  Created by 김건호 on 1/26/24.
//

import SwiftUI

struct KakaoLoginView: View {
    @StateObject private var viewModel = KakaoLoginViewModel()
    
    
    var body: some View {
        Button {
            viewModel.kakaoAuthSignIn()
        } label: {
            ZStack {
                Image("KakaoLogo")
                    .resizable()
                    .frame(width: 18, height: 18)
                
                Circle()
                    .stroke(Color(hex: "D9D9D9"))
                    .frame(width: 39)
                    .foregroundColor(.white)
            }
        }
    }
    //    .padding(.bottom, 40)
}

#Preview {
    KakaoLoginView()
}
