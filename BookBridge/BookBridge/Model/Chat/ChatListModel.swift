//
//  ChatListModel.swift
//  BookBridge
//
//  Created by jmyeong on 2/5/24.
//

import Foundation

struct ChatList: Hashable, Identifiable {
    var id: String                         //보류
    var userId: String                     //나
    var noticeBoardId: String              //게시물 아이디
    var opponentId: String                 //채팅 보낸사람 아이디    받아와서 ->
    var noticeBoardTitle: String           //게시물 제목
    var message: String?                   //최근 채팅
    var date: Date?                        //채팅목록 최근 시간
    var isAlarm: Bool                      //채팅방 알림 여부(푸시)
    var state: [Int]                       //채팅방 상태 [아무것도 없음, 예약중, 교환완료
    var exchangeLocation: [Double?]        // 0번은 위도, 1번은 경도
    
}
