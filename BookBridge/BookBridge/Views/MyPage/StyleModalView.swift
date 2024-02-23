//
//  StyleModalView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI

struct StyleModalView: View {
    @Binding var isModal: Bool
    
    @StateObject var viewModel: StyleViewModel
    
    var userId: String
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 120, height: 5)
                .foregroundStyle(Color(uiColor: .systemGray5))
                .cornerRadius(5)
                .padding(.top, 10)
            
            Image(viewModel.style.imageName)
                .resizable()
                .frame(width: 90, height: 90)
                .padding(.bottom, 10)
            
            Text(viewModel.style.title)
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 10)
            
            Text(viewModel.style.description)
                .font(.system(size: 17))
                .padding(.bottom, 10)
            
            if (viewModel.myStyles.contains { $0 == viewModel.style.title }) {    //칭호 보유중
                Button {
                    viewModel.changeSelectedStyle()
                    isModal = false
                } label: {
                    Text(viewModel.selectedStyle == viewModel.style.title ? "선택취소" : "선택완료")
                        .padding(.vertical, 5)
                        .padding(.horizontal,8)
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .foregroundStyle(.white)
                        .background(Color(hex: "59AAE0"))
                        .cornerRadius(20)
                }
            } else {
                Text("획득하지 못했어요 ㅠㅠ")
                    .padding(.vertical, 5)
                    .padding(.horizontal,8)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .foregroundStyle(.white)
                    .background(Color(hex: "EE5050"))
                    .cornerRadius(20)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
