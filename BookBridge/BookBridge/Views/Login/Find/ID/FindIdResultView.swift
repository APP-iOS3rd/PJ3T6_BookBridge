//
//  FindIdResultView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//


import SwiftUI

struct FindIdResultView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @StateObject var viewModel: FindIdViewModel
    @State var email = ""
    
    var body: some View {
        VStack{
            Image("Character")
            
            
            VStack(alignment: .leading){
                
                
                Text("가입한 이메일")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "000000"))
                
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "F7F8FC"))
                            .frame(width: 355, height: 93)
                        VStack{
                            Text(email)
                                .font(.system(size: 20 , weight: .regular))
                                .foregroundStyle(Color(hex: "000000"))
                                .frame(maxWidth: .infinity, alignment: .leading) // 텍스트를 왼쪽으로 정렬
                                .padding(.leading, 10)
                           
                        }
                    }
                }
            }
            
            
            
            Spacer()
                .frame(height: 220)
            
            
            
            Button(action: {
                pathModel.paths.append(.findpassword)
            }, label: {
                Text("비밀번호 찾기")
            })
            .foregroundColor(.white)
            .font(.system(size: 20).bold())
            .frame(width: 353, height: 50) // 여기에 프레임을 설정
            .background(Color(hex: "59AAE0"))
            .cornerRadius(10)
                                            
            
            
            Button(action: {
                pathModel.paths.removeSubrange(1...pathModel.paths.count-1)
            }, label: {
                Text("확인")
            })
            .foregroundColor(.white)
            .font(.system(size: 20).bold())
            .frame(width: 353, height: 50) // 여기에 프레임을 설정
            .background(Color(hex: "59AAE0"))
            .cornerRadius(10)
        }
        .onAppear() {
            viewModel.getEmail(with: $email)
        }
        .padding(20)
        .navigationBarTitle("아이디 찾기", displayMode: .inline)        
    }
}

#Preview {
    FindIdResultView(viewModel: FindIdViewModel())
}
