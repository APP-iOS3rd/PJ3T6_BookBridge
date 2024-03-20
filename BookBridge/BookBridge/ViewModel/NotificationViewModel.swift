//
//  NotificationViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 3/11/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var partnerImageUrl: String = ""
    @Published var isShowNotificationBadge: Bool = false
    @Published var isBadgeDisplayed: Bool = false
    
    var listener: ListenerRegistration?
    
    let db = Firestore.firestore()
}

//MARK: - 상대방 평가 기능
extension NotificationViewModel {
    
    // 상대방 평가 시 정보 업데이트
    func updatePartnerReview(partnerId: String, reviewIndex: Int) {
        let partnerDocumentRef = FirebaseManager.shared.firestore.collection("User").document(partnerId)
        
        partnerDocumentRef.getDocument { documentSnapshot, error in
            guard let document = documentSnapshot else { return }
            
            var newReviews = document.data()?["reviews"] as? [Int] ?? [0, 0, 0]
            
            newReviews[reviewIndex] += 1
            
            let updatedData: [String: Any] = ["reviews": newReviews]
            
            partnerDocumentRef.updateData(updatedData) { error in
                guard error == nil else { return }
            }
        }
    }
    
    // 새로운 알림 평가정보 저장
    func saveNotification(notification: NotificationModel) {
        do {
            let documentRef = db.collection("User").document(notification.userId).collection("notification").document(notification.id)
            try documentRef.setData(from: notification)
        } catch {
            print("Notification 저장실패")
        }
    }
}

//MARK: - 실시간 알림 감지
extension NotificationViewModel {
    // Firestore에서 알림 변경 사항을 실시간으로 감지하는 메서드
    func startNotificationListener() {
        let uid = UserManager.shared.uid
        
        if !uid.isEmpty {
            let collectionPath = "User/\(uid)/notification"
            let collectionListenr = db.collection(collectionPath)
            
            listener = collectionListenr.addSnapshotListener{ snapshot, error in
                
                guard let snapshot = snapshot else {
                    print("변경사항을 불러오는중 오류가 발생하였습니다.")
                    return
                }
                
                var notifications = [NotificationModel]()
                snapshot.documentChanges.forEach { [weak self] change in
                    switch change.type {
                    case .added:
                        print("알람 추가사항이 감지되었습니다.")
                        do {
                            if let notification = try? change.document.data(as: NotificationModel.self) {
                                notifications.append(notification)
                                self?.isShowNotificationBadge = true
                            } else {
                                print("notification decoding 실패")
                                self?.isShowNotificationBadge = false
                            }
                        }
                    default: break
                    }
                }
                
                self.notifications.append(contentsOf: notifications)
                self.notifications.sort { $0.date > $1.date }
            }
        }
    }
    
    func startNotificationListenerIfNeeded() {
        if self.listener == nil {
            startNotificationListener()
        }
    }
    
    func stopNotificationListener() {
        listener?.remove()
        resetNotifications()
    }
    
    func resetNotifications() {
        self.notifications = []
    }
                          
  func deleteNotification(id: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("User").document(uid).collection("notification").document(id).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
                return
            } else {
                DispatchQueue.main.async {
                    self.notifications.removeAll { $0.id == id }
                }
            }
        }
    }
}

//MARK: - isRead변경사항 Firebase 저장

extension NotificationViewModel {
    func updateIsRead(notificationId: String) {
        print("updateIsRead 실행")
        print("notificationId: \(notificationId)")
        
        let db = Firestore.firestore()
        let userId = UserManager.shared.uid
                        
        db.collection("User").document(userId).collection("notification")
            .whereField("id", isEqualTo: notificationId)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("해당 id에대한 notification 문서를 찾을 수 없습니다.\n\(err)")
                } else {
                    for document in querySnapshot!.documents {
                        // 문서의 'isRead' 필드를 'true'로 업데이트합니다.
                        document.reference.updateData(["isRead": true]) { error in
                            if let error = error {
                                print("notification isRead 업데이트가 실패했습니다.\n\(error)")
                            } else {
                                print("notification isRead 업데이트가 성공했습니다.")
                            }
                        }
                    }
                }
        }
    }
    
    func isShowBadge(notifications: [NotificationModel]) -> Bool {
        for notification in notifications {
            if !notification.isRead {
                return true
            }
        }
        
        return false
    }
}



