//
//  NotificationViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 3/12/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NotificationViewModel: ObservableObject {
    
    @Published var notifications: [NotificationModel] = []
    
    var listener: ListenerRegistration?
    let db = Firestore.firestore()
    
    //MARK: Firestore에서 알림 변경 사항을 실시간으로 감지하는 메서드
    func startNotificationListener() {
        // 현재 사용자의 UID 가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        listener?.remove()
        notifications.removeAll()
        
        // 알림 리스너 설정
        listener = db.collection("User").document(uid).collection("notification")
            .order(by: "date", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                // 가져온 알림 문서들을 NotificationModel로 변환하여 배열에 저장
                self.notifications = documents.compactMap { queryDocumentSnapshot -> NotificationModel? in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let userId = data["userId"] as? String ?? ""
                    let noticeBoardId = data["noticeBoardId"] as? String ?? ""
                    let chatRoomId = data["chatRoomId"] as? String ?? ""
                    let partnerId = data["partnerId"] as? String ?? ""
                    let noticeBoardTitle = data["noticeBoardTitle"] as? String ?? ""
                    let nickName = data["nickName"] as? String ?? ""
                    let timestamp = data["date"] as? Timestamp ?? Timestamp()
                    let date = timestamp.dateValue()
                    
                    return NotificationModel(id: id, userId: userId, noticeBoardId: noticeBoardId, chatRoomId: chatRoomId, partnerId: partnerId, noticeBoardTitle: noticeBoardTitle, nickName: nickName, date: date)
                }
            }
    }
    
    func saveNotification(notification: NotificationModel) {
        // Firestore에 알림 추가
        do {
            let documentRef = db.collection("User").document(notification.userId).collection("notification").document()
            try documentRef.setData(from: notification)
        } catch {
            print("Error saving notification to Firestore: \(error)")
        }
    }
}

