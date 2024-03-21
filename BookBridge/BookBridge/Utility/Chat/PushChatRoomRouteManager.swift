//
//  PushChatRoomRouteManager.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/03/07.
//

import Foundation
import UIKit

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
    @Published var message: String?
    @Published var profileImage: UIImage?
    @Published var reviews: [Int]?
    //채팅방 바로 가기 핸들 변수
    @Published var isShowingChatMessageView: Bool = false
    
    func navigateToChatRoom(chatRoomId: String, userId: String, partnerId: String, noticeBoardTitle: String, noticeBoardId: String, nickname: String, style: String, profileURL: String, message: String, reviews: [Int] ) {
        self.chatRoomId = chatRoomId
        self.userId = userId
        self.partnerId = partnerId
        self.noticeBoardId = noticeBoardId
        self.noticeBoardTitle = noticeBoardTitle
        self.nickname = nickname
        self.style = style
        self.profileURL = profileURL
        self.message = message
        self.isShowingChatMessageView = true
        self.reviews = reviews
        
        Task {
            // 비동기 함수에서 이미지를 로드하고 결과를 받기
            if let loadedImage = await loadProfileImage(from: profileURL) {
                // MainActor를 사용 메인 스레드에서 @Published 프로퍼티를 업데이트
                await MainActor.run { self.profileImage = loadedImage }
            }
        }
    }
}
extension PushChatRoomRouteManager {
    func loadProfileImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
}
