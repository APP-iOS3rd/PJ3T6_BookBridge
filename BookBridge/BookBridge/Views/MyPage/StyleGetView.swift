//
//  StyleGetView.swift
//  BookBridge
//
//  Created by 노주영 on 3/8/24.
//

import SwiftUI

struct StyleGetView: View {
    @State private var isShowAlert = false
    @State private var isShowFirstView = true
    
    var style: StyleType
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            
            VStack {
                switch style {
                case .newBi:
                    Image("Newbi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .padding(.top, 20)
                case .bookHope:
                    Image("WishBooks")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .padding(.top, 20)
                case .bookDic:
                    Image("Encyclopedia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .padding(.top, 20)
                }
                
                Text("획득한 칭호는 내 프로필 -> 칭호 설정에서 변경하실 수 있어요")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color(hex: "767676"))
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
            }
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
