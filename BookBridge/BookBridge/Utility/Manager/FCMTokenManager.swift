//
//  FCMTokenManager.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/21.
//

import Foundation
import FirebaseMessaging

class FCMTokenManager {
    static let shared = FCMTokenManager()
    
    private init() {}
    
    func fetchFCMToken(completion: @escaping (String?) -> Void){
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM 등록 토큰: \(error)")
                completion(nil)
            } else if let token = token {
                print("FCM 등록 토큰: \(token)")
                completion(token)
            }
        }
    }
}
