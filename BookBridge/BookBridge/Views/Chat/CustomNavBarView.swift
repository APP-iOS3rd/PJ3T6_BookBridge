//
//  CustomNavBarView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI

struct CustomNavBarView: View {
    @StateObject var viewModel: ChatRoomListViewModel
    
    @State var isShowSheet = false
    
    var body: some View {
        HStack(spacing: 16) {
            // 프로필 이미지 가져오기
            AsyncImage(url: URL(string: viewModel.currentUser?.profileURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black, lineWidth: 1)
                            .shadow(radius: 5)
                    )
            } placeholder: {
                // Placeholder 이미지 (로딩 중 표시될 이미지)
                ProgressView()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.currentUser?.email ?? "")
                    .font(.system(size: 24, weight: .bold))
                HStack {
                    Circle()
                        .foregroundStyle(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(.lightGray))
                }
            }
            Spacer()
            Button {
                isShowSheet.toggle()
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $isShowSheet) {
            ActionSheet(
                title: Text("알림"),
                message: Text("로그아웃 하시겠습니까?"),
                buttons: [
                    .destructive(Text("로그아웃"), action: {
                        print("handle sign out")
                        //viewModel.doSignOut()
                    }),
                    .cancel()
                ]
            )
        }
    }
}
