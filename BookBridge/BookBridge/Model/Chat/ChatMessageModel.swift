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
        //시간 정제
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd\nHH:mm"
        let fixDate = "\(formatter.string(from: date))"
        
        return fixDate
    }
}
