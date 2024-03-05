//
//  dwwadaView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    @Binding var selectedTab: Int
    @Binding var stack: NavigationPath
    
    @StateObject var viewModel = MyPageViewModel()
    
    var otherUser: UserModel?
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                if otherUser == nil {
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
                } else {
                    KFImage(URL(string: otherUser?.profileURL ?? ""))
                        .placeholder{
                            Image("Character")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .cornerRadius(35)
                        }
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(35)
                        .overlay(RoundedRectangle(cornerRadius: 35)
                            .stroke(Color(hex: "D9D9D9"), lineWidth: viewModel.userSaveImage.1 == UIImage(named: "Character")! ? 2 : 0)
                        )
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text((otherUser?.style == "" ? "칭호없음" : otherUser?.style) ?? "칭호없음")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 8)
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: "4B4B4C"))
                            .background(Color(hex: "D9D9D9"))
                            .cornerRadius(5)
                        
                        Text(otherUser?.nickname ?? "")
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.top, 10)
            
            //매너점수
            ReviewScoreView(otherUser: otherUser)
            
            if otherUser == nil {
                //나의 게시물
                MyPostView(selectedTab: $selectedTab, stack: $stack, viewModel: viewModel)
                
                //계정 관리
                AccountManagementView(selectedTab: $selectedTab, stack: $stack, viewModel: viewModel)
            } else {
                Divider()
                
                NoticeBoardView(selectedTab: $selectedTab, stack: $stack, naviTitle: "내 게시물", noticeBoardArray: [], otherUser: otherUser, sortTypes: ["전체", "진행중", "예약중", "교환완료"])
            }
            Spacer()
        }
        .padding(.horizontal)
        .toolbar {
            if otherUser == nil {
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
        }
        .onAppear {
            viewModel.userSaveImage = ("", UIImage(named: "Character")!)
            
            if UserManager.shared.uid != "" {
                viewModel.getUserInfo(otherUser: otherUser)
                viewModel.getDownLoadImage(otherUser: otherUser)
            }
        }
    }
}
