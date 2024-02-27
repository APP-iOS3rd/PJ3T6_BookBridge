//
//  InquiryModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/27/24.
//

import SwiftUI

struct InquiryCategory: Identifiable, Codable {
    var id = UUID().uuidString
    var categories: String
    var inquiryUserId: String // 문의한 사용자 ID
    var category: InquiryCategory // 문의 유형
    var inquiryComments: String? // 문의 내용
    var inquiryDate: Date // 문의 날짜
    
    enum InquiryCategory: String, Codable, CaseIterable {
        case accountInquiry = "계정 문의"
        case chatInquiry = "채팅 문의"
        case notificationInquiry = "알림 문의"
        case exchangeInquiry = "교환 문의"
        case townSettingInquiry = "동네설정 문의"
        case other = "기타"

    }
}
