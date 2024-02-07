//
//  MyPageScoreView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct MyScoreView: View {
    var body: some View {
        HStack {
            VStack(spacing: 5) {
                Text("만족해요")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "4B4B4C"))
                    .background(Color(hex: "EDD1AF"))
                    .cornerRadius(5)
                
                Text("70")
                    .font(.system(size: 17, weight: .semibold))
            }
            
            Spacer()
            Rectangle()
                .frame(maxHeight: .infinity)
                .frame(width: 2)
                .foregroundStyle(Color.init(hex: "B3B3B3"))
            Spacer()
            
            VStack(spacing: 5) {
                Text("보통이에요")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "4B4B4C"))
                    .background(Color(hex: "FBE6CA"))
                    .cornerRadius(5)
                
                Text("20")
                    .font(.system(size: 17, weight: .semibold))
            }
            
            Spacer()
            Rectangle()
                .frame(maxHeight: .infinity)
                .frame(width: 2)
                .foregroundStyle(Color.init(hex: "B3B3B3"))
            Spacer()
            
            VStack(spacing: 5) {
                Text("별로에요")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "4B4B4C"))
                    .background(Color(hex: "FDF1E0"))
                    .cornerRadius(5)
                
                Text("10")
                    .font(.system(size: 17, weight: .semibold))
            }
            
            Spacer()
            Rectangle()
                .frame(maxHeight: .infinity)
                .frame(width: 2)
                .foregroundStyle(Color.init(hex: "B3B3B3"))
            Spacer()
            
            VStack(spacing: 5) {
                Text("매너점수")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "4B4B4C"))
                    .background(Color(hex: "FFD9E5"))
                    .cornerRadius(5)
                
                Text("80점")
                    .font(.system(size: 17, weight: .semibold))
            }
        }
        .frame(height: 45)
        .padding(.horizontal, 10)
        .padding(.bottom, 20)
    }
}

#Preview {
    MyScoreView()
}

