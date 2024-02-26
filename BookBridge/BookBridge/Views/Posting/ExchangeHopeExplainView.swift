//
//  ExchangeHopeExplainView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/06.
//

import SwiftUI

struct ExchangeHopeExplainView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("교환하고 싶은 장소를 선택해주세요.")
                .frame(maxWidth: .infinity, alignment: .leading)              
                .font(.system(size: 20))
                .bold()
                .padding(.leading,14)
                .padding(.top,16)
                .padding(.bottom,14)
                
            Text("누구나 찾기 쉬운 장소를 선택하는 것이 좋아요.")
                .frame(maxWidth: .infinity, alignment: .leading)              
                .font(.system(size: 14))
                .padding(.leading,14)
                .padding(.bottom,14)
            Spacer()
        }
        .background(Color.white) // 배경색을 흰색으로 설정
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    //현재 View 닫기
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

