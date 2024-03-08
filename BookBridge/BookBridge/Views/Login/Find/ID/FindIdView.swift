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
    @FocusState var isFocused: Bool
    @State var isLoading = false
    @State var isComplete = false
    
    
    var body: some View {
        ZStack {
                                    
            ClearBackground(isFocused: $isFocused)
            
            VStack(alignment: .leading) {
                
                Text("휴대폰번호를 알려주세요")
                    .font(.system(size: 30, weight: .semibold))
                
                Spacer()
                    .frame(height: 8)
                
                Text("가입 당시의 휴대폰번호를 알려주세요")
                    .foregroundStyle(Color(hex: "#848787"))
                    .font(.system(size: 15, weight: .regular))
                                
                
                Spacer()
                    .frame(height: 80)
                    
                                        
                FindIdInputView(
                    findIdVM: viewModel,
                    isFocused: $isFocused,
                    type: .phone,
                    placeholder: "-없이 입력해 주세요"
                )
                
                           
                Spacer()
                    
                if !isFocused {
                    Button(action: {
                        viewModel.verifyPhoneNumber(
                            isLoading: $isLoading,
                            isComplete: $isComplete
                        )
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
            }
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

