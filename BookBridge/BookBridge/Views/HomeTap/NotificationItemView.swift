//
//  AlarmItemVIew.swift
//  BookBridge
//
//  Created by 김건호 on 3/12/24.
//

import SwiftUI

struct NotificationItemView: View {
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
                HStack {
                    if notificationModel.isRead == false{
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit) //비율유지
                            .frame(height: 15)
                            .foregroundColor(.red)
                    }

                    Text("\(notificationModel.noticeBoardTitle)")
                        .foregroundColor(.black)
                        .bold()
                    Text("게시물 평가알림")
                        .foregroundColor(.black)
                }
                
                HStack(alignment: .top, spacing: 1) {
                    Text("\"\(notificationModel.nickname)\"".useNonBreakingSpace())
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .bold() +
                    Text(notificationModel.isReview ? "님이 최근 교환에 평가를 남겼어요." : "님이 최근 교환에 평가를 남겼어요. 상대방을 평가한 후 결과를 확인해주세요.")
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                }
                .opacity(0.6)
                .multilineTextAlignment(.leading)
                
                Text("\(notificationModel.timeAgo)")
                    .font(.caption)
                    .foregroundStyle(Color(.lightGray))
            }
        }
    }
    
}

//양쪽 정렬
extension String {
    func useNonBreakingSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "\u{202F}\u{202F}")
    }
}
