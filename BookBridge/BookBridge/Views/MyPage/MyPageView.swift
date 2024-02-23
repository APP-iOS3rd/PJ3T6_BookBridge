//
//  dwwadaView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI

struct MyPageView: View {
    @Binding var isShowPlusBtn: Bool
    @Binding var selectedTab : Int
    @StateObject var viewModel = MyPageViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(uiImage: viewModel.userSaveImage.1)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(35)
                    .overlay(RoundedRectangle(cornerRadius: 35)
                        .stroke(Color(hex: "D9D9D9"), lineWidth: viewModel.userSaveImage.1 == UIImage(named: "Character")! ? 2 : 0)
                    )
                
                VStack(alignment: .leading, spacing: 10) {
                    Text((viewModel.userManager.user?.style == "" ? "칭호없음" : viewModel.userManager.user?.style) ?? "칭호없음")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "4B4B4C"))
                        .background(Color(hex: "D9D9D9"))
                        .cornerRadius(5)
                    
                    Text(viewModel.userManager.user?.nickname ?? "")
                        .font(.system(size: 20, weight: .bold))
                }
                
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.top, 10)
            
            //매너점수
            ReviewScoreView()
            
            //나의 게시물
            MyPostView(isShowPlusBtn: $isShowPlusBtn, viewModel: viewModel)
            
            //계정 관리
            AccountManagementView(isShowPlusBtn: $isShowPlusBtn, viewModel: viewModel)
            
            Spacer()
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingView(selectedTab: $selectedTab)
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isShowPlusBtn = true
            }
            
            if UserManager.shared.uid != "" {
                viewModel.getUserInfo()
                viewModel.getDownLoadImage()
            }
        }
    }
}
