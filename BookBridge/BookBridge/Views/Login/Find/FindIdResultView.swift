//
//  FindIdResultView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//


import SwiftUI

struct FindIdResultView: View {
    @State private var isNavigationActive = false // 화면 전환 상태 관리
    
    var body: some View {
        VStack{
            Image("Character")
            
            VStack(alignment: .leading){
                
                Text("가입한 아이디")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "000000"))
                
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "F7F8FC"))
                            .frame(width: 355, height: 93)
                        VStack{
                            Text("BOOKBRID")
                                .font(.system(size: 20 , weight: .regular))
                                .foregroundStyle(Color(hex: "000000"))
                                .frame(maxWidth: .infinity, alignment: .leading) // 텍스트를 왼쪽으로 정렬
                                .padding(.leading, 10)
                            Text("가입날짜")
                                .font(.system(size: 16 , weight: .regular))
                                .foregroundStyle(Color(hex: "959595"))
                                .frame(maxWidth: .infinity, alignment: .leading) // 텍스트를 왼쪽으로 정렬
                                .padding(.leading, 10)

                        }
                        
                    }
                    
                }
            }
            
            
            
            Spacer()
                .frame(height: 200)
            
            
            NavigationLink(destination: FindPasswordView(signUpVM: SignUpVM()).navigationBarBackButtonHidden(), isActive: $isNavigationActive) {
                EmptyView()
            }
            
            
            Button(action: {
                self.isNavigationActive = true // 버튼 클릭 시 화면 전환
            }, label: {
                Text("비밀번호 찾기")
            })
            .foregroundColor(.white)
            .font(.system(size: 20).bold())
            .frame(width: 353, height: 50) // 여기에 프레임을 설정
            .background(Color(hex: "59AAE0"))
            .cornerRadius(10)
                                            
            
            
            Button(action: {
                
            }, label: {
                Text("확인")
            })
            .foregroundColor(.white)
            .font(.system(size: 20).bold())
            .frame(width: 353, height: 50) // 여기에 프레임을 설정
            .background(Color(hex: "59AAE0"))
            .cornerRadius(10)
        }
        .padding(20)
        .navigationBarTitle("아이디 찾기", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
    }
}

#Preview {
    FindIdResultView()
}
