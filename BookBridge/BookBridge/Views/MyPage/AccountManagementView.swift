//
//  MyAccountManagementView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct AccountManagementView: View {
    @Binding var selectedTab: Int

    @StateObject var viewModel: MyPageViewModel
    @StateObject var userManager = UserManager.shared
    
    @State private var isPassword: Bool = false
    @State private var isPhone: Bool = false
    @State private var showPasswordView: Bool = false
    @State private var showPhoneView: Bool = false
    
    
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
            }
            Divider()
            
            Button {
                if userManager.user?.password == "" {
                    isPassword.toggle()
                } else {
                    showPasswordView.toggle()
                }
            } label: {
                HStack {
                    Text("비밀번호 변경")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            Divider()
            .alert("SNS 로그인은 비밀번호를 변경할 수 없습니다.", isPresented: $isPassword, actions: {
                Button("확인", role: .cancel) {
                    isPassword.toggle()
                }
            }, message: {
                
            })
            
            Button {
                if userManager.user?.password == "" {                    
                    isPhone.toggle()
                } else {
                    showPhoneView.toggle()
                }
            } label: {
                HStack {
                    Text("전화번호 변경")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            Divider()
            .alert("SNS 로그인은 전화번호를 변경할 수 없습니다.", isPresented: $isPhone, actions: {
                Button("확인", role: .cancel) {
                    isPassword.toggle()
                }
            }, message: {
                
            })

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
            }
            Divider()
            
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
            } 
            Divider()
            
            NavigationLink {
                BlockUserManagementView()
            } label: {
                HStack {
                    Text("차단 사용자 관리")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            Divider()
        }
        .navigationDestination(isPresented: $showPasswordView) {
            MyProfilePasswordView()
        }
        .navigationDestination(isPresented: $showPhoneView) {
            ConfirmPasswordView(showPhoneView: $showPhoneView)            
        }
    }
}
