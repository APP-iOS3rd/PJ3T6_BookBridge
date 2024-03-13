//
//  AlarmItemVIew.swift
//  BookBridge
//
//  Created by 김건호 on 3/12/24.
//

import SwiftUI

struct NotificationItemVIew: View {
    var notificationModel: NotificationModel
    
    var body: some View {
            HStack(alignment: .top, spacing: 10) {
                Image("Character")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle().stroke(Color(hex: "D9D9D9"), lineWidth: 1)
                    )
                
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 1) {
                    Text("\(notificationModel.nickname)")
                        .bold() +
                    Text("님이 \"\(notificationModel.noticeBoardTitle)\"에 대한 교환완료 평가를 남겼어요.")
                }
                .multilineTextAlignment(.leading)
                
                Text("\(notificationModel.timeAgo)")
                    .font(.caption)
                    .foregroundStyle(Color(.lightGray))
            }
        }
    }
}

