//
//  NaverLoginView.swift
//  BookBridge
//
//  Created by 노주영 on 1/29/24.
//

import SwiftUI
import NaverThirdPartyLogin

struct NaverLoginView: View {
    private var naverLoginManger = NaverAuthManager.shared
    
    var body: some View {
        VStack {
            Button{
                naverLoginManger.doNaverLogin()
            } label: {
                Image("naverLogo")
                    .resizable()
                    .frame(width: 36, height: 36)
            }
        }
    }
}

#Preview {
    NaverLoginView()
}
