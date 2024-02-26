//
//  FindPasswordView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//

import SwiftUI

struct FindPasswordView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @StateObject private var viewModel = FindIdVM()
    @State private var isNavigationActive = false // 화면 전환 상태 관리
    
    var body: some View {
        
        
        VStack {
            
            Image("Character")
            
            
            VStack(alignment: .leading,spacing: 5 ) {
                
                Text("가입할 때 입력한 아이디와 \n 이메일을 입력해주세요")
                    .font(.system(size: 20, weight: .regular))
                                
                
                Spacer()
                    .frame(height: 50)
                
                Text("아이디")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "999999"))
                
                TextField("아이디를 입력해주세요", text: $viewModel.email)
                    .padding()
                    .foregroundColor(Color(hex: "3C3C43"))
                    .frame(height: 36)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "F7F8FC"))
                    .cornerRadius(5.0)
                
                Spacer()
                    .frame(height: 5)
                
                
                Text("이메일")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "999999"))
                HStack {
                    TextField("이메일을 입력해 주세요", text: $viewModel.email)
                        .padding()
                        .foregroundColor(Color(hex: "3C3C43"))
                        .frame(height: 36)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "F7F8FC"))
                        .cornerRadius(5.0)
                    
                    Button {
                        viewModel.sendMail()
                        print("메일을 전송하였습니다.")
                    } label: {
                        Text("인증하기")
                            .font(.system(size: 17))
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 36)
                            .background(Color(hex: "59AAE0"))
                            .cornerRadius(5.0)
                    }
                }
                
                Spacer()
                    .frame(height: 5)
                
                
                Text("인증 번호")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "999999"))
                HStack {
                    TextField("인증번호를 입력해주세요", text: $viewModel.userAuthCode)
                        .padding()
                        .foregroundColor(Color(hex: "3C3C43"))
                        .frame(height: 36)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "F7F8FC"))
                        .cornerRadius(5.0)
                    
                    ResendBtn()
                }
                
                
                Spacer()
                    
                
                
                

                
                Button(action: {
                    if viewModel.isCertiCode(){
                        pathModel.paths.append(.changepassword)
                    }
                    else{
                        pathModel.paths.append(.changepassword) // 임시로 추가
                    }
                }, label: {
                    Text("인증완료")
                })
                .foregroundColor(.white)
                .font(.system(size: 20).bold())
                .frame(width: 353, height: 50) // 여기에 프레임을 설정
                .background(Color(hex: "59AAE0"))
                .cornerRadius(10)
                
            }
            
            
            
            
        }
        .padding(20)
        
        .navigationBarTitle("비밀번호 찾기", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        
    }
    
    
    @ViewBuilder
    func ResendBtn() -> some View {
        Button {
            viewModel.sendMail()
        } label: {
            Text("재전송")
                .font(.system(size: 17))
                .foregroundStyle(Color(hex: "59AAE0"))
                .frame(width: 100, height: 36)
                .border(Color(hex: "59AAE0"), width: 2)
                .background(.white)
                .cornerRadius(5.0)
        }
    }
    
    
}

