//
//  FindPasswordView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//

import SwiftUI

struct FindPasswordView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @StateObject var viewModel: SMSAuthViewModel
    @State private var isNavigationActive = false // 화면 전환 상태 관리
    @State var isLoading = false
    @State var isComplete = false
    
    var body: some View {
        
        VStack {
            
            
            VStack(alignment: .leading,spacing: 5 ) {
                
                Spacer()
                    .frame(height: 50)
                
                Text("가입할 때 입력한\n이메일을 입력해주세요")
                    .font(.system(size: 35, weight: .semibold))
                                
                
                Spacer()
                    .frame(height: 180)
                    
                
                
                LoginInputView(
                    viewModel: viewModel,
                    type: .email,
                    title: "이메일",
                    placeholder: "이메일을 입력해주세요",
                    btnTitle: "확인하기"
                )
                
                
                Spacer()
                    

        
                Button {
                    if viewModel.verifyEmailEmpty() {
                        viewModel.sendPasswordReset(
                            isLoading: $isLoading,
                            isComplete: $isComplete
                        )
                    }
                } label: {
                    HStack {
                        if isLoading {
                            LoadingCircle(size: 15, color: "FFFFFF")
                        }
                        Text("확인")
                    }
                    .modifier(LargeBtnStyle())
                }
                                
            }
        }
        .padding(20)
        .navigationBarTitle("비밀번호 찾기", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        .alert(isPresented: $isComplete) {
            Alert(title: Text("메세지 전송"),
                  message: Text("비밀번호 변경 메세지가 전송되었습니다."),
                  primaryButton: .default(Text("확인"), action: {
                     pathModel.paths.removeSubrange(1...pathModel.paths.count-1)
                  }),
                  secondaryButton: .cancel())
        }
        
    }
    
}

#Preview {
    FindPasswordView(viewModel: SMSAuthViewModel())
}
