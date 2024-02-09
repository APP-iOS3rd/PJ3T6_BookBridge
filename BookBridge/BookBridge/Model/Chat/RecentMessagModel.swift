//
//  RecentMessagModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/7/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct RecentMessage: Codable, Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let text: String
    let fromId: String
    let email: String
    let toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.email = data[FirebaseConstants.email] as? String ?? ""
        self.profileImageUrl = data[FirebaseConstants.profileImageUrl] as? String ?? ""
        self.timestamp = (data[FirebaseConstants.timestamp] as? Timestamp)?.dateValue() ?? Date()
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
