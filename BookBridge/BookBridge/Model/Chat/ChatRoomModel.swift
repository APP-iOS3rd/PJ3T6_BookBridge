//
//  ChatRoom.swift
//  BookBridge
//
//  Created by 이현호 on 2/14/24.
//

import Foundation

struct ChatRoom: Codable, Hashable, Identifiable {
    
    var id: String = UUID().uuidString         //ForEach용
    let documentId: String
    var userId: String                     //나(보류)
    var noticeBoardId: String              //게시물 아이디
    var opponentId: String                 //채팅 상대방 아이디
    var noticeBoardTitle: String           //게시물 제목
    var recentMessage: String?             //최근 채팅
    var date: Date?                        //채팅목록 최근 시간
    var isAlarm: Bool                      //채팅방 알림 여부(푸시)
    var newCount: Int                      //메시지알림 개수 표시
    var state: [Int]                       //채팅방 상태 [아무것도 없음, 예약중, 교환완료]
//    var exchangeLocation: [Double?]        // 0번은 위도, 1번은 경도 (보류)
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.userId = data[FirebaseConstants.userId] as? String ?? ""
        self.noticeBoardId = data[FirebaseConstants.noticeBoardId] as? String ?? ""
        self.opponentId = data[FirebaseConstants.opponentId] as? String ?? ""
        self.noticeBoardTitle = data[FirebaseConstants.noticeBoardTitle] as? String ?? ""
        self.recentMessage = data[FirebaseConstants.recentMessage] as? String
        if let dateString = data[FirebaseConstants.date] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.date = formatter.date(from: dateString)
        } else {
            self.date = nil
        }
        self.isAlarm = data[FirebaseConstants.isAlarm] as? Bool ?? false
        self.newCount = data[FirebaseConstants.newCount] as? Int ?? 0
        self.state = data[FirebaseConstants.state] as? [Int] ?? []
//        self.exchangeLocation = data[FirebaseConstants.exchangeLocation] as? [Double?]
    }
}
