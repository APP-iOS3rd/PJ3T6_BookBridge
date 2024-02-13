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
            HStack {
                Button(action: {
                    //현재 View 닫기
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                        .padding(.leading,14)
                }
                Spacer()
            }
            Spacer()
            Text("교환하고 싶은 장소를 선택해주세요.")
                .frame(maxWidth: .infinity, alignment: .leading)              .font(.system(size: 24))
                .padding(.leading,14)
                .padding(.top,14)
                .padding(.bottom,14)
                
            Text("누구나 찾기 쉬운 장소를 선택하는 것이 좋아요.")
                .frame(maxWidth: .infinity, alignment: .leading)              .font(.system(size: 14))
                .padding(.leading,14)
                .padding(.bottom,14)
            Spacer()
        }
        .background(Color.white) // 배경색을 흰색으로 설정
    }
}

