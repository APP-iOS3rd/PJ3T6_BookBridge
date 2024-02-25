//
//  SettingView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingLogoutAlert = false
    @State private var showingLoginView = false
    @Binding var selectedTab: Int
    var body: some View {
        VStack {
            NavigationLink {
                AlarmSettingView()
            } label: {
                HStack {
                    Text("알림")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            .padding(.top, 10)
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("개인 정보 처리 방침")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("문의 및 건의사항")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            
            HStack {
                Text("버전")
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                Spacer()
                Text("1.2.0 v01")
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            
            HStack {
                Text("로그아웃")
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.red)
                Spacer()
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            
            HStack {
                Button {
                    showingLogoutAlert = true
                    showingLoginView = false
                } label: {
                    Text("회원탈퇴")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.red)
                    Spacer()
                }
                .alert(isPresented: $showingLogoutAlert) {
                    Alert(
                        title: Text("회원 탈퇴"),
                        message: Text("정말로 회원탈퇴를 하시겠습니까?"),
                        primaryButton: .destructive(Text("탈퇴하기")) {
                            UserManager.shared.deleteUserAccount { success in
                                if success {
                                    dismiss()
                                    selectedTab = 0
                                    print("회원 탈퇴가 성공적으로 처리되었습니다.")
                                    
                                } else {
                                    showingLoginView = true
                                    print("회원 탈퇴 처리에 실패했습니다.")
                                    
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
            )
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("설정")
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

//#Preview {
//    SettingView()
//}

