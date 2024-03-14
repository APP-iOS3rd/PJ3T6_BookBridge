//
//  NotificationModel.swift
//  BookBridge
//
//  Created by 이현호 on 3/12/24.
//

import Foundation
import FirebaseFirestore

struct NotificationModel: Identifiable, Hashable, Codable, Equatable {
    var id = UUID().uuidString
    var userId: String                          //나
    var noticeBoardId: String                   //게시물 아이디
    var partnerId: String                       //평가남긴 상대방 아이디
    var partnerImageUrl: String                 //상대방 ImageURl
    var noticeBoardTitle: String                //게시물 제목
    var nickname: String                        //상대방 닉네임
    var review: String                          //만족도
    var date: Date                              //알림 시간
    var isRead: Bool                            //사용자가 알람을 읽었는지 확인
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
