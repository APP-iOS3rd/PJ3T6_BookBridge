//
//  AlarmItemVIew.swift
//  BookBridge
//
//  Created by 김건호 on 3/12/24.
//

import SwiftUI

struct NotificationItemVIew: View {
    @StateObject var notificationViewModel: NotificationViewModel
    
    var notificationModel: NotificationModel
    var nickname: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 1) {
                Text("\(notificationViewModel.notifications.)")
                    .bold() +
                Text("님이 \"게시글제목\"에 대한 교환완료 평가를 남겼어요.")
            }
            .multilineTextAlignment(.leading)
            
            Text("1분 전")
                .font(.caption)
                .foregroundStyle(Color(.lightGray))
        }
    }
}

