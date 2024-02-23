//
//  PostUserInfoView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

struct PostUserInfoView: View {
    @StateObject var postViewModel: PostViewModel
    
    var body: some View {
        HStack {
            Image(systemName: postViewModel.user.profileURL ?? "scribble")
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .background(
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
                )
            VStack(alignment: .leading) {
                Text("중고도서킬러")
                    .padding(1)
                    .font(.system(size: 12))
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255)))
                Text(postViewModel.user.nickname ?? "책벌레")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .padding(.vertical, 1)
                    .padding(.horizontal, 3)
                Text(postViewModel.user.getSelectedLocation()?.dong ?? "")
                    .font(.system(size: 10))
                    .foregroundStyle(Color(red: 153/255, green: 153/255, blue: 153/255))
            }
            Spacer()
            Text("매너점수")
                .font(.system(size: 12))
            Text("90점")
                .padding(.vertical, 1)
                .padding(.horizontal, 3)
                .font(.system(size: 12))
                .fontWeight(.semibold)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color(red: 255/255, green: 222/255, blue: 201/255)))
        }
        .padding(.horizontal)
    }
}
