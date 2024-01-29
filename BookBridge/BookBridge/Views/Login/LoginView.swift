//
//  Login.swift
//  BookBridge
//
//  Created by 이민호 on 1/25/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        HStack{
            LoginGoogleView()
            KakaoLoginView()
            NaverLoginView()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
