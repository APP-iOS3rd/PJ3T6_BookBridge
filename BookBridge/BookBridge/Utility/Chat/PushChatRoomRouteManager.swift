//
//  PushChatRoomRouteManager.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/03/07.
//

import Foundation
import SwiftUI

// 푸시알람 클릭시 채팅방 이동관련 Manager
class PushChatRoomRouteManager: ObservableObject {
    
    static let shared = PushChatRoomRouteManager()
    
    @Published var chatRoomId: String?
    @Published var userId: String?
    @Published var partnerId: String?
    @Published var noticeBoardTitle: String?
    @Published var noticeBoardId: String?
    @Published var nickname: String?
    @Published var style: String?
    @Published var profileURL: String?
    
    func navigateToChatRoom(chatRoomId: String, userId: String, partnerId: String, noticeBoardTitle: String, noticeBoardId: String, nickname: String, style: String, profileURL: String) {
        self.chatRoomId = chatRoomId
        self.userId = userId
        self.partnerId = partnerId
        self.noticeBoardId = noticeBoardId
        self.noticeBoardTitle = noticeBoardTitle
        self.nickname = nickname
        self.style = style
        self.profileURL = profileURL
        
    }
}
