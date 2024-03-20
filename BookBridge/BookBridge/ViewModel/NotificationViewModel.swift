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
    func saveNotification(notification: NotificationModel, isReview: Bool) {
        let documentRef = db.collection("User").document(notification.userId).collection("notification").document(notification.id)
        
        documentRef.getDocument { document, error in
            do {
                // isReview 값을 notification에 설정
                var notificationIsReview = notification
                notificationIsReview.isReview = isReview
                
                try documentRef.setData(from: notificationIsReview)
            } catch {
                print("Error saving document: \(error)")
            }
        }
    }
    
    // 알림 평가정보 업데이트
    func updateIsReview(notificationId: String) {
        print("updateIsReview 실행")
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
                        // 문서의 'isReview' 필드를 'true'로 업데이트합니다.
                        document.reference.updateData(["isReview": true]) { error in
                            if let error = error {
                                print("notification isReview 업데이트가 실패했습니다.\n\(error)")
                            } else {
                                print("notification isReview 업데이트가 성공했습니다.")
                            }
                        }
                    }
                }
            }
    }
}

//MARK: - 실시간 알림 감지
extension NotificationViewModel {
    // Firestore에서 알림 변경 사항을 실시간으로 감지하는 메서드
    func startNotificationListener() {
        // 현재 사용자의 UID 가져오기
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        // 알림 리스너 설정
        listener = db.collection("User").document(uid).collection("notification")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                if ((querySnapshot?.documentChanges) != nil) {
                    
                    guard let documents = querySnapshot?.documents else { return }
                    
                    self?.notifications.removeAll()
                    
                    for document in documents {
                        let data = document.data()
                        let id = data["id"] as? String ?? ""
                        let userId = data["userId"] as? String ?? ""
                        let noticeBoardId = data["noticeBoardId"] as? String ?? ""
                        let partnerId = data["partnerId"] as? String ?? ""
                        let noticeBoardTitle = data["noticeBoardTitle"] as? String ?? ""
                        let nickname = data["nickname"] as? String ?? ""
                        let timestamp = data["date"] as? Timestamp
                        let review = data["review"] as? String ?? ""
                        let date = timestamp?.dateValue() ?? Date()
                        let isRead = data["isRead"] as? Bool ?? false
                        let isReview = data["isReview"] as? Bool ?? false
                        
                        FirebaseManager.shared.firestore.collection("User").document(partnerId).getDocument { [weak self] documentSnapshot, error in
                            guard let document = documentSnapshot, error == nil else { return }
                            let partnerImageUrl = document.data()?["profileURL"] as? String ?? ""
                            
                            // 메인 스레드에서 UI 업데이트
                            DispatchQueue.main.async {
                                let notification = NotificationModel(
                                    id: id,
                                    userId: userId,
                                    noticeBoardId: noticeBoardId,
                                    partnerId: partnerId,
                                    partnerImageUrl: partnerImageUrl,
                                    noticeBoardTitle: noticeBoardTitle,
                                    nickname: nickname,
                                    review: review,
                                    date: date,
                                    isRead: isRead,
                                    isReview: isReview
                                )
                                
                                
                                DispatchQueue.main.async {
                                    self?.notifications.append(notification)
                                    self?.notifications.sort(by: { $0.date > $1.date })
                                }
                            }
                        }
                        print("변경사항 감지")
                        // isRead가 하나라도 있으면 isShowNotificationBadge는 false
                        
                        if ((self?.isShowBadge(notifications: self?.notifications ?? [])) != nil) {
                            print("false가 하나라도 있음")
                            self?.isShowNotificationBadge = true
                        } else {
                            print("false가 없음")
                            self?.isShowNotificationBadge = false
                        }
                    }
                }
            }
    }
    
    // 실시간 배지 호출
    func displayBadge() {
        startNotificationListener()
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



