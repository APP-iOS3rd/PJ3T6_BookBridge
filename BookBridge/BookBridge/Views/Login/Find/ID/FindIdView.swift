//
//  FindIdView.swift
//  BookBridge
//
//  Created by 김건호 on 1/30/24.
//

import SwiftUI

struct FindIdView: View {
    @EnvironmentObject private var pathModel: PathViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: FindIdViewModel
    @State var isLoading = false
    @State var isComplete = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("\n휴대폰번호를\n입력해주세요")
                .font(.system(size: 30, weight: .semibold))
                            
            
            Spacer()
                .frame(height: 120)
                
                                    
            FindIdInputView(
                viewModel: viewModel,
                type: .phone,
                placeholder: "-없이 입력해 주세요"
            )
            
                       
            Spacer()
                
                                                    
            Button(action: {
                // 1. 휴대폰번호 맞는지 확인 (Firebase에서 확인)
                // 2. 휴대폰번호로 문자보내기
                // 3. 다음화면으로 넘어가기
                // 4. 휴대폰 번호, 상태메시지 지우기
                viewModel.verifyPhoneNumber(isLoading: $isLoading, isComplete: $isComplete)
            }, label: {
                HStack {
                    if isLoading {
                        LoadingCircle(size: 15, color: "FFFFFF")
                    }
                    Text("확인")
                }
            })
            .modifier(LargeBtnStyle())
            
        }
        .padding(20)
        .navigationBarTitle("아이디 찾기", displayMode: .inline)
        .onChange(of: isComplete) { _ in
            if isComplete {
                pathModel.paths.append(.findIdCerti)
                isComplete = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.resetPhoneNumber()
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        
    }
}
#Preview {
    FindIdView(viewModel: FindIdViewModel())
}

