//
//  MyAccountManagementView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct AccountManagementView: View {
    @StateObject var viewModel: MyPageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("계정 관리")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 10)
            
            NavigationLink {
                MyProfileView(nickname: viewModel.userManager.user?.nickname ?? "", userSaveImage: viewModel.userSaveImage)
            } label: {
                HStack {
                    Text("프로필")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
                )
            }
            
            NavigationLink {                //관심목록 경로가 아직없음
                NoticeBoardView(naviTitle: "관심목록", noticeBoardArray: viewModel.userBookMarks, sortTypes: ["전체", "진행중", "예약중", "교환완료"])
            } label: {
                HStack {
                    Text("관심목록")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
                )
            }
           
            NavigationLink {
                TownSettingView()
            } label: {
                HStack {
                    Text("동네설정")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
                )
            }
            
            NavigationLink {
                //유저 아이디에 사용자 아이디 넣기, 유저 스타일에 사용자 대표 칭호 넣기
                StyleSettingView(userId: viewModel.userManager.uid, userStyle: viewModel.userManager.user?.style ?? "")
            } label: {
                HStack {
                    Text("칭호관리")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
                )
            }
        }
    }
}
