//
//  Login.swift
//  BookBridge
//
//  Created by 이민호 on 1/25/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView{
            VStack{
                Image("Character")
                VStack(alignment: .leading,spacing : 10){
                    Text("다 읽고 안보는책 \n자리만 차지하는책\n다른 책으로 교환하고 싶다면?")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(Color(hex: "999999"))
                    
                    Text("책다리")
                        .font(.system(size: 48, weight: .medium)) // "책다리" 부분만 글꼴 크기 키움
                        .foregroundColor(Color(hex: "000000")) +
                    Text("에서 교환 해봐")
                        .font(.system(size: 35, weight: .medium))
                        .foregroundColor(Color(hex: "000000"))
                    
                    Spacer()
                        .frame(height: 130)
                    
                    
                }
                NavigationLink(destination: EmailSignUpView()) {
                    Text("시작하기")
                        .foregroundColor(.white)
                        .font(.system(size: 20).bold())
                        .frame(width: 353, height: 50) // 여기에 프레임을 설정
                        .background(Color(hex: "59AAE0"))
                        .cornerRadius(10)
                }
                
                Spacer()
                    .frame(height: 20)
                
                HStack{
                    Text("이미 계정이 있으신가요?")
                        .font(.system(size: 16, weight: .light))
                    NavigationLink(destination: IdLoginView()) {
                        Text("로그인")
                            .foregroundColor(Color(hex: "3A87FD"))
                            .underline()
                    }
                }
                
                HStack{
                    Text("로그인 없이")
                        .font(.system(size: 16, weight: .light))
                    NavigationLink(destination: SignUpView()) {
                        Text("둘러보기")
                            .foregroundColor(Color(hex: "3A87FD"))
                            .underline()
                    }
                    .navigationBarBackButtonHidden(true)
                }
                
                Spacer()
                    .frame(height: 50)
                
                HStack {
                    // 왼쪽 가로 Divider
                    Rectangle()
                        .frame(width: 100, height: 1) // 가로 길이 96, 높이 1
                        .foregroundColor(Color(hex:"A7A7A7"))

                    Text("SNS 계정으로")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex:"A7A7A7"))
                        .padding(.horizontal, 10)

                    // 오른쪽 가로 Divider
                    Rectangle()
                        .frame(width: 100, height: 1) // 가로 길이 96, 높이 1
                        .foregroundColor(Color(hex:"A7A7A7"))
                }



                HStack(spacing: 20){
                    LoginGoogleView()
                    KakaoLoginView()
                    AppleLoginView()
                }
                Spacer()
                    .frame(height: 50)
                
            }
            .padding(20)
        }
        
        
    }
}

#Preview {
    LoginView()
}
