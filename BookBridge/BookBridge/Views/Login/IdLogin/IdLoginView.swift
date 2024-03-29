//
//  IdLoginView.swift
//  BookBridge
//
//  Created by 김건호 on 1/29/24.
//

import SwiftUI

struct IdLoginView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @StateObject private var viewModel = IdLoginViewModel()
    @FocusState var isFocused: Bool
    @Binding var showingLoginView: Bool
    @State private var isShowImage : Bool = true
    
    var body: some View {
        ZStack {
            
            ClearBackground(isFocused: $isFocused)
            
            VStack{
                
                if !isFocused {
                    Image("Character")
                }
                                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Spacer()
                        .frame(height: 85)
                    
                    
                    Text("이메일")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "999999"))
                    
                    IdLoginInputView(
                        viewModel: viewModel,
                        isFocused: $isFocused,
                        type: .id,
                        placeholder: "이메일을 입력하세요"
                    )
                    
                                    
                    Spacer()
                        .frame(height: 5)

                    
                    Text("비밀번호")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "999999"))
                    
                    IdLoginInputView(
                        viewModel: viewModel,
                        isFocused: $isFocused,
                        type: .password,
                        placeholder: "비밀번호를 입력하세요"
                    )
                    
                                        
                    HStack{
                        
                        Button(action: {
                            pathModel.paths.append(.findId)
                        }, label: {
                            Text("이메일찾기")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color(hex: "999999"))
                                .underline()
                        })
                        
                        
                        Spacer()
                        
                        Button(action: {
                            pathModel.paths.append(.findpassword)
                        }, label: {
                            Text("비밀번호찾기")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color(hex: "999999"))
                                .underline()
                        })
                        
                    }
                    
                }
                
                
                Spacer()
                
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                } else {
                    if !isFocused {
                        Button(action: {
                            viewModel.login()
                            if viewModel.state == .signedIn {
                                showingLoginView = false
                            }
                        }, label: {
                            Text("로그인")
                        })
                        .alert(isPresented: $viewModel.isAlert) {
                            Alert(title: Text("이메일 또는 비밀번호가 틀렸습니다."))
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 20).bold())
                        .frame(width: 353, height: 50) // 여기에 프레임을 설정
                        .background(Color(hex: "59AAE0"))
                        .cornerRadius(10)
                    }                    
                }
            }
        }
        
        .onChange(of: viewModel.state) { newState in
            if newState == .signedIn {
                showingLoginView = false
            }
        }
        .padding(20)
        .onTapGesture{
            hideKeyboard()
        }
        .navigationBarTitle("로그인", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        
    }
    
}


struct CustomBackButtonView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .foregroundStyle(.black)
        }
    }
}



//#Preview {
//    IdLoginView()
//}
