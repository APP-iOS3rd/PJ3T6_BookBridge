//
//  NotificationModel.swift
//  BookBridge
//
//  Created by 이현호 on 3/12/24.
//

import Foundation
import FirebaseFirestore

struct NotificationModel: Identifiable, Hashable, Codable {
    var id: String
    var userId: String                          //나
    var noticeBoardId: String                   //게시물 아이디
    var chatRoomId: String                      //채팅방 아이디
    var partnerId: String                       //상대방 아이디
    var noticeBoardTitle: String                //게시물 제목
    var nickName: String                        //상대방 닉네임
    var date: Date                              //알림 시간
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
