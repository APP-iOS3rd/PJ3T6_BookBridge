//
//  FirebaseConstants.swift
//  BookBridge
//
//  Created by 이현호 on 2/8/24.
//

import Foundation

struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let email = "email"
    static let uid = "uid"
    static let profileImageUrl = "profileImageUrl"
    static let messages = "messages"
    static let users = "chatUsers"
    static let recentMessages = "recent_messages"
    static let userId = "userId" // 나(보류)
    static let noticeBoardId = "noticeBoardId" //게시물 아이디
    static let opponentId = "opponentId" //채팅 상대방 아이디
    static let noticeBoardTitle = "noticeBoardTitle" //게시물 제목
    static let recentMessage = "recentMessage" //최근 채팅
    static let date = "date" //채팅목록 최근 시간
    static let isAlarm = "isAlarm" //채팅방 알림 여부(푸시)
    static let newCount = "newCount" //메시지알림 개수 표시
    static let state = "state" //채팅방 상태 [아무것도 없음, 예약중, 교환완료]
    static let exchangeLocation = "exchangeLocation" // 0번은 위도, 1번은 경도 (보류)
}
