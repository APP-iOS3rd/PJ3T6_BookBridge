//
//  ChatRoom.swift
//  BookBridge
//
//  Created by 이현호 on 2/14/24.
//

import Foundation
import FirebaseFirestore

struct ChatRoomListModel: Identifiable {
    var id: String                              //ForEach용
    var userId: String                          //나(보류)
    var noticeBoardId: String                   //게시물 아이디
    var partnerId: String                       //채팅 상대방 아이디
    var noticeBoardTitle: String                //게시물 제목
    var recentMessage: String                   //최근 채팅
    var date: Date                              //채팅목록 최근 시간
    var isAlarm: Bool                           //채팅방 알림 여부(푸시)
    var newCount: Int                           //메시지알림 개수 표시
    var state: [Int]                            //채팅방 상태 [진행중, 예약중, 교환완료]
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    //    var exchangeLocation: [Double?]        // 0번은 위도, 1번은 경도 (보류)
}
