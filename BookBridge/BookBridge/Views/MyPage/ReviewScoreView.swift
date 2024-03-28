//
//  MyPageScoreView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct ReviewScoreView: View {
    @StateObject var viewModel = ReviewScoreViewModel()
    
    var otherUser: UserModel?
    
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
                
                if otherUser == nil {
                    Text("\(viewModel.userManager.user?.reviews?[0] ?? 0)")
                        .font(.system(size: 17, weight: .semibold))
                } else {
                    Text("\(otherUser?.reviews?[0] ?? 0)")
                        .font(.system(size: 17, weight: .semibold))
                }
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
                
                if otherUser == nil {
                    Text("\(viewModel.userManager.user?.reviews?[1] ?? 0)")
                        .font(.system(size: 17, weight: .semibold))
                } else {
                    Text("\(otherUser?.reviews?[1] ?? 0)")
                        .font(.system(size: 17, weight: .semibold))
                }
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
                
                if otherUser == nil {
                    Text("\(viewModel.userManager.user?.reviews?[2] ?? 0)")
                        .font(.system(size: 17, weight: .semibold))
                } else {
                    Text("\(otherUser?.reviews?[2] ?? 0)")
                        .font(.system(size: 17, weight: .semibold))
                }            }
            
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
                
                Text(viewModel.mannerScore == -1 ? "평점없음" : "\(viewModel.mannerScore)점")
                    .font(.system(size: 17, weight: .semibold))
            }
        }
        .frame(height: 45)
        .padding(.horizontal, 10)
        .padding(.bottom, 20)
        .onAppear {
            viewModel.getMannerScore(otherUser: otherUser)                                  
        }
    }
}


