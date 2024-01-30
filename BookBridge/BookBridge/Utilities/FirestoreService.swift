//
//  FirestoreService.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/01/30.
//

import Foundation
import AuthenticationServices
import FirebaseFirestore
import FirebaseStorage

class FirestoreService {
    static let shared = FirestoreService()

    private init() {}

    func saveUserToFirestore(user: UserModel) {
        let db = Firestore.firestore()

        let userData = [
            "id": user.id ?? "",
            "loginId": user.loginId ?? "",
            "nickname": user.nickname ?? "",
            "joinDate": Date(),
            "fcmToken": user.fcmToken ?? ""
        ] as [String : Any]

        db.collection("User").document(user.id ?? "").setData(userData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("저장 성공")
            }
        }
    }
}
