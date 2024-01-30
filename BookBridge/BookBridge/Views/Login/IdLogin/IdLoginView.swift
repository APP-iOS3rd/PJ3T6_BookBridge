//
//  IdLoginView.swift
//  BookBridge
//
//  Created by 김건호 on 1/29/24.
//

import SwiftUI

struct IdLoginView: View {
    
    @StateObject private var viewModel = IdLoginViewModel()
    @StateObject var signUpVM =  SignUpVM()
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                Image("Character")
                
                Spacer()
                    .frame(height: 85)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("아이디")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "999999"))
                    
                    TextField("아이디를 입력하세요", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .background(Color(hex: "F7F8FC"))
                                        
                    Text(viewModel.usernameErrorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                        .opacity(viewModel.usernameErrorMessage.isEmpty ? 0 : 1)
                    
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text("비밀번호")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "999999"))
                    
                    SecureField("비밀번호를 입력하세요", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .background(Color(hex: "F7F8FC"))
                    
                    
                    Text(viewModel.passwordErrorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 10))
                        .opacity(viewModel.usernameErrorMessage.isEmpty ? 0 : 1)
                
                    
                    
                    HStack{
                        NavigationLink(destination: FindIdView(signUpVM: signUpVM)) {
                            Text("아이디찾기")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color(hex: "999999"))
                                .underline()
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("비밀번호찾기")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color(hex: "999999"))
                                .underline()
                        }
                        
                    }
                    
                }
                
                
                Spacer()
                    .frame(height: 200)
                
                Button(action: {
                    viewModel.login()
                }, label: {
                    Text("로그인")
                })
                .foregroundColor(.white)
                .font(.system(size: 20).bold())
                .frame(width: 353, height: 50) // 여기에 프레임을 설정
                .background(Color(hex: "59AAE0"))
                .cornerRadius(10)
            }
            .padding(20)
            
        }
        
        
    }
}


struct CustomBackButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    let title: String
    
    var body: some View {
        HStack {
            // 커스텀 백 버튼
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .frame(width: 32,height: 31)
                    .foregroundColor(Color(hex: "000000"))
            }
            
            Text(title)
                .font(.system(size: 24).bold())
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(20)
        .navigationBarBackButtonHidden(true) // 기본 백 버튼 숨기기
    }
}



#Preview {
    IdLoginView()
}
