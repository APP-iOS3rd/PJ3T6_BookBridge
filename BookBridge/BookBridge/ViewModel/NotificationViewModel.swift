//
//  NotificationViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 3/11/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine

class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var partnerImageUrl: String = ""
    @Published var isShowNotificationBadge: Bool = false
    @Published var isBadgeDisplayed: Bool = false
    
    
    var listener: ListenerRegistration?
    private var cancellables: Set<AnyCancellable> = []
    
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
                    print("알람 변경사항을 불러오는중 오류가 발생하였습니다.")
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
                                print("startNotificationListener에서 notification decoding이 실패하였습니다.")
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

extension NotificationViewModel {
    func updateReview(notification: NotificationModel, notificationId: String, isReview: Bool) {
        // 첫 번째 단계: updateIsReview 실행
        updateIsReview(notificationId: notificationId)
            .flatMap { [unowned self] _ -> AnyPublisher<[NotificationModel], Error> in
                // 두 번째 단계: fetchNotifications 실행 (결과는 사용하지 않음)
                return self.fetchNotifications(forUserId: UserManager.shared.uid)
            }
            .flatMap { [unowned self] _ -> AnyPublisher<Void, Error> in
                // 세 번째 단계: 매개변수로 받은 notification만 저장
                return self.saveNotification(notification: notification, isReview: isReview)
            }
            .receive(on: DispatchQueue.main) // UI 업데이트를 위해 메인 스레드에서 결과 수신
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("리뷰 프로세스가 성공적으로 완료되었습니다.")
                case .failure(let error):
                    print("리뷰 프로세스 중 오류 발생: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                print("알림이 성공적으로 저장되었습니다.")
            })
            .store(in: &cancellables)
    }
    
    func updateIsReview(notificationId: String) -> AnyPublisher<Void, Error> {
        let db = Firestore.firestore()
        let userId = UserManager.shared.uid
        
        return Future<Void, Error> { promise in
            db.collection("User").document(userId).collection("notification")
                .whereField("id", isEqualTo: notificationId)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        promise(.failure(err))
                    } else {
                        let batch = db.batch()
                        querySnapshot!.documents.forEach { doc in
                            batch.updateData(["isReview": true], forDocument: doc.reference)
                        }
                        batch.commit { error in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchNotifications(forUserId uid: String) -> AnyPublisher<[NotificationModel], Error> {
        let db = Firestore.firestore()
        let collectionPath = "User/\(uid)/notification"
        
        return Future<[NotificationModel], Error> { promise in
            db.collection(collectionPath).getDocuments { querySnapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let notifications = querySnapshot!.documents.compactMap { document -> NotificationModel? in
                        return try? document.data(as: NotificationModel.self)
                    }
                    self.notifications = notifications
                    self.notifications.sort { $0.date > $1.date }
                    promise(.success(notifications))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveNotification(notification: NotificationModel, isReview: Bool) -> AnyPublisher<Void, Error> {
        let db = Firestore.firestore()
        let documentRef = db.collection("User").document(notification.userId)
                          .collection("notification").document(notification.id)
        
        return Future<Void, Error> { promise in
            documentRef.getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                do {
                    var updatedNotification = notification
                    updatedNotification.isReview = isReview
                    
                    try documentRef.setData(from: updatedNotification) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveNotificationIsReview(notification: NotificationModel, isReview: Bool) {
        saveNotification(notification: notification, isReview: isReview)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("알림이 성공적으로 저장되었습니다.")
                case .failure(let error):
                    print("알림 저장 중 오류 발생: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                // 성공 시 수행할 작업 (여기서는 성공 메시지 출력 외에 별도 작업 없음)
            })
            .store(in: &self.cancellables)
    }
}
