//
//  FindPasswordResultView.swift
//  BookBridge
//
//  Created by 이민호 on 3/7/24.
//

import SwiftUI

struct FindPasswordResultView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @StateObject var viewModel: FindPasswordViewModel
    @State var isLoading = false
    @State var isComplete = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Spacer()
                    .frame(height: 70)
                                               
                Text("메세지를 전송했어요")
                    .foregroundStyle(.black)
                    .font(.system(size: 30, weight: .semibold))
                
                Spacer()
                    .frame(height: 8)
                
                Text("메세지에서 비밀번호를 변경할 수 있어요")
                    .foregroundStyle(Color(hex: "#848787"))
                    .font(.system(size: 15, weight: .regular))
                
                
                Spacer()
                    .frame(height: 80)
                
                Text("메세지를 받지 못하셨나요?")
                    .foregroundStyle(.black)
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                    .frame(height: 10)
                
                Button {
                    viewModel.getReservedEmail()
                    viewModel.verifyEmail(isLoading: $isLoading, isComplete: $isComplete)
                } label: {
                    Text("메세지 다시 전송하기")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color(hex: "59AAE0"))
                }
                                
                Spacer()
                
                Button {
                    viewModel.resetReservedEmail()
                    pathModel.paths.removeSubrange(1...pathModel.paths.count-1)
                } label: {
                    Text("로그인하러가기")
                        .modifier(LargeBtnStyle())
                }
            }
            
            if isLoading {
                LoadingCircle(size: 25, color: "59AAE0")
            }
        }
        .padding(.horizontal)
        .alert(isPresented: $isComplete) {
            Alert(
                title: Text("메세지가 전송되었습니다"),
                dismissButton: .default(Text("확인")) {                                        
                }
            )
        }
    }
}

#Preview {
    FindPasswordResultView(viewModel: FindPasswordViewModel())
}
