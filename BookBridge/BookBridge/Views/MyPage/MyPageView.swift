//
//  dwwadaView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI

struct MyPageView: View {
    @StateObject var viewModel = MyPageViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 20) {
                    Image("bearGlass")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(35)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("뉴비")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: "4B4B4C"))
                            .background(Color(hex: "D9D9D9"))
                            .cornerRadius(5)
                        
                        Text("닉네임")
                            .font(.system(size: 20, weight: .bold))
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.top, 10)
                
                //매너점수
                ReviewScoreView(userId: "joo")
                
                //나의 게시물
                MyPostView(viewModel: viewModel)
                
                //계정 관리
                AccountManagementView(viewModel: viewModel)
                
                Spacer()
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                    }
                }
            }
            .onAppear {
                viewModel.getUserInfo()
            }
        }
    }
}

#Preview {
    MyPageView()
}

