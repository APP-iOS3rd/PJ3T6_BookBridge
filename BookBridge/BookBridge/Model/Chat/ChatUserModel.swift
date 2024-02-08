//
//  ChatUserModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import Foundation

struct ChatUser: Identifiable {
    
    var id: String { uid }
    
    let uid: String
    let email: String
    let profileImageUrl: String
    var messages: [ChatMessage] // 사용자의 모든 메시지
    var recentMessages: [RecentMessage] // 사용자의 최근 메시지
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.messages = []
        self.recentMessages = []
    }
}
