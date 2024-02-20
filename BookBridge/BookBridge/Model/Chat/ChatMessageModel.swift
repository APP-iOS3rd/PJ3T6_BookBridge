//
//  ChatListModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/5/24.
//

import Foundation
import FirebaseFirestore

struct ChatMessageModel: Identifiable {
    
    let id = UUID().uuidString
    var date: Date
    var imageURL: String
    var location: [String]
    var message: String
    var sender: String
    
    var timeAgo: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
