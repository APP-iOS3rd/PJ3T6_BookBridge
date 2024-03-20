//
//  NotificationModel.swift
//  BookBridge
//
//  Created by 이현호 on 3/12/24.
//

import Foundation
import FirebaseFirestore

struct NotificationModel: Identifiable, Hashable, Codable, Equatable {
    var id = UUID().uuidString
    var userId: String
    var noticeBoardId: String
    var partnerId: String
    var partnerImageUrl: String
    var noticeBoardTitle: String
    var nickname: String
    var review: String
    var date: Date
    var isRead: Bool
    var isReview: Bool
    
    init(userId: String, noticeBoardId: String, partnerId: String, partnerImageUrl: String, noticeBoardTitle: String, nickname: String, review: String, isRead: Bool, isReview: Bool) {
        self.id = UUID().uuidString
        self.userId = userId
        self.noticeBoardId = noticeBoardId
        self.partnerId = partnerId
        self.partnerImageUrl = partnerImageUrl
        self.noticeBoardTitle = noticeBoardTitle
        self.nickname = nickname
        self.review = review
        self.date = Date()
        self.isRead = isRead
        self.isReview = isReview
    }

    // Computed property to format the date, not encoded/decoded
    var timeAgo: String {
        if date > Calendar.current.date(byAdding: .day, value: -7, to: Date())! {
            let formatter = RelativeDateTimeFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.localizedString(for: date, relativeTo: Date())
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy. MM. dd."
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
    }
    
    // MARK: - Encode and Decode for Firestore Unix Time Stamp
    private enum CodingKeys: String, CodingKey {
        case id, userId, noticeBoardId, partnerId, partnerImageUrl, noticeBoardTitle, nickname, review, date, isRead, isReview
    }
    
    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        noticeBoardId = try container.decode(String.self, forKey: .noticeBoardId)
        partnerId = try container.decode(String.self, forKey: .partnerId)
        partnerImageUrl = try container.decode(String.self, forKey: .partnerImageUrl)
        noticeBoardTitle = try container.decode(String.self, forKey: .noticeBoardTitle)
        nickname = try container.decode(String.self, forKey: .nickname)
        review = try container.decode(String.self, forKey: .review)
        let timestamp = try container.decode(Timestamp.self, forKey: .date)
        date = timestamp.dateValue()
        isRead = try container.decode(Bool.self, forKey: .isRead)
        isReview = try container.decode(Bool.self, forKey: .isReview)
    }
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(noticeBoardId, forKey: .noticeBoardId)
        try container.encode(partnerId, forKey: .partnerId)
        try container.encode(partnerImageUrl, forKey: .partnerImageUrl)
        try container.encode(noticeBoardTitle, forKey: .noticeBoardTitle)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(review, forKey: .review)
        try container.encode(isRead, forKey: .isRead)
        try container.encode(date, forKey: .date)
        try container.encode(isReview, forKey: .isReview)
    }
}
