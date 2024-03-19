//
//  ChatLogViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatMessageViewModel: ObservableObject {
    
    @Published var bookImage: UIImage = UIImage(named: "DefaultImage")!
    @Published var chatImages: [String: UIImage] = [:]
    @Published var chatMessages: [ChatMessageModel] = []
    @Published var chatText = ""
    @Published var count = 0
    @Published var noticeBoardInfo: NoticeBoard = NoticeBoard(userId: "", noticeBoardTitle: "", noticeBoardDetail: "", noticeImageLink: [], noticeLocation: [], noticeLocationName: "", isChange: false, state: 0, date: Date(), hopeBook: [], reservationId: "")
    @Published var reservationName: String = ""
    @Published var saveChatRoomId: String = ""
    @Published var selectedImages: [UIImage] = []
    
    var firestoreListener: ListenerRegistration?
    
    let nestedGroup = DispatchGroup()
    let nestedGroupImage = DispatchGroup()
}

//MARK: 정보 가져오기
extension ChatMessageViewModel {
    // 메시지 가져오기
    func fetchMessages(uid: String) {
        // 실시간 업데이트 감시
        firestoreListener = FirebaseManager.shared.firestore.collection("User").document(uid).collection("chatRoomList").document(saveChatRoomId).collection("messages").order(by: "date", descending: false).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot else { return }
            
            self.chatMessages.removeAll()
            
            // 메시지 전송: 중복 x
            for document in documents.documents {
                guard let changeTime = document.data()["date"] as? Timestamp else { return }
                
                self.chatMessages.append(ChatMessageModel(
                    date: changeTime.dateValue(),
                    imageURL: document.data()["imageURL"] as? String ?? "",
                    location: document.data()["location"] as? [Double] ?? [100, 200],
                    message: document.data()["message"] as? String ?? "",
                    sender: document.data()["sender"] as? String ?? ""
                ))
            }
            
            // 자동 스크롤 비동기
            DispatchQueue.main.async {
                self.count += 1
            }
        }
    }
    
    //게시물 정보 가져오기
    func getNoticeBoardInfo(noticeBoardId: String) {
        self.noticeBoardInfo = NoticeBoard(userId: "", noticeBoardTitle: "", noticeBoardDetail: "", noticeImageLink: [], noticeLocation: [], noticeLocationName: "", isChange: false, state: 0, date: Date(), hopeBook: [])
        
        let query = FirebaseManager.shared.firestore.collection("noticeBoard").document(noticeBoardId)
        
        query.getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            guard let stamp = document.data()?["date"] as? Timestamp else { return }
            guard let isChange = document.data()?["isChange"] as? Bool else { return }
            guard let noticeImageLink = document.data()?["noticeImageLink"] as? [String] else { return }
            guard let reservationId = document.data()?["reservationId"] as? String else { return }
            
            if isChange {          //바꿔요 게시물
                let noticeBoard = NoticeBoard(
                    id: document.data()?["noticeBoardId"] as? String ?? "",
                    userId: document.data()?["userId"] as? String ?? "",
                    noticeBoardTitle: document.data()?["noticeBoardTitle"] as? String ?? "",
                    noticeBoardDetail: document.data()?["noticeBoardDetail"] as? String ?? "",
                    noticeImageLink: noticeImageLink,
                    noticeLocation: document.data()?["noticeLocation"] as? [Double] ?? [],
                    noticeLocationName: document.data()?["noticeLocationName"] as? String ?? "",
                    isChange: document.data()?["isChange"] as? Bool ?? false,
                    state: document.data()?["state"] as? Int ?? 0,
                    date: stamp.dateValue(),
                    hopeBook: [],
                    reservationId: reservationId
                )
                
                self.getReservationName(reservationId: reservationId)
                self.getNoticeBoardImage(urlString: noticeImageLink[0])
                
                DispatchQueue.main.async {
                    self.noticeBoardInfo = noticeBoard
                }
            } else {                                                    //구해요 게시물
                query.collection("hopeBooks").getDocuments { querySnapshot2, err2 in
                    guard err2 == nil else { return }
                    guard let hopeDocuments = querySnapshot2?.documents else { return }
                    
                    var hopeBooks: [Item] = []
                    
                    for doc in hopeDocuments {
                        if doc.exists {
                            self.nestedGroup.enter() // Enter nested DispatchGroup
                            
                            query.collection("hopeBooks").document(doc.documentID).collection("industryIdentifiers").getDocuments { (querySnapshot, error) in
                                guard let industryIdentifiers = querySnapshot?.documents else {
                                    self.nestedGroup.leave()
                                    return
                                }
                                
                                var isbn: [IndustryIdentifier] = []
                                
                                for industryIdentifier in industryIdentifiers {
                                    isbn.append(IndustryIdentifier(identifier: industryIdentifier.documentID))
                                }
                                
                                let item = Item(id: doc.documentID, volumeInfo: VolumeInfo(
                                    title: doc.data()["title"] as? String ?? "",
                                    authors: (doc.data()["authors"] as? [String] ?? [""]),
                                    publisher: doc.data()["publisher"] as? String ?? "",
                                    publishedDate: doc.data()["publishedDate"] as? String ?? "",
                                    description: doc.data()["description"] as? String ?? "",
                                    industryIdentifiers: isbn,
                                    pageCount: doc.data()["pageCount"] as? Int ?? 0,
                                    categories: doc.data()["categories"] as? [String] ?? [""],
                                    imageLinks: ImageLinks(smallThumbnail: doc.data()["imageLinks"] as? String ?? "")))
                                
                                hopeBooks.append(item)
                                
                                self.nestedGroup.leave() // Leave nested DispatchGroup
                            }
                        } else {
                            self.nestedGroup.leave() // Leave nested DispatchGroup
                        }
                    }
                    
                    self.nestedGroup.notify(queue: .main) {
                        // All tasks in nested DispatchGroup completed
                        let noticeBoard = NoticeBoard(
                            id: document.data()?["noticeBoardId"] as? String ?? "",
                            userId: document.data()?["userId"] as? String ?? "",
                            noticeBoardTitle: document.data()?["noticeBoardTitle"] as? String ?? "",
                            noticeBoardDetail: document.data()?["noticeBoardDetail"] as? String ?? "",
                            noticeImageLink: document.data()?["noticeImageLink"] as? [String] ?? [],
                            noticeLocation: document.data()?["noticeLocation"] as? [Double] ?? [],
                            noticeLocationName: document.data()?["noticeLocationName"] as? String ?? "",
                            isChange: document.data()?["isChange"] as? Bool ?? false,
                            state: document.data()?["state"] as? Int ?? 0,
                            date: stamp.dateValue(),
                            hopeBook: hopeBooks,
                            reservationId: document.data()?["reservationId"] as? String ?? ""
                        )
                        
                        self.getReservationName(reservationId: document.data()?["reservationId"] as? String ?? "")
                        
                        if hopeBooks.isEmpty {
                            self.bookImage = UIImage(named: "DefaultImage")!
                        } else {
                            print(hopeBooks[0])
                            self.getNoticeBoardImage(urlString: hopeBooks[0].volumeInfo.imageLinks?.smallThumbnail ?? "")
                        }
                        
                        DispatchQueue.main.async {
                            self.noticeBoardInfo = noticeBoard
                        }
                    }
                }
            }
        }
    }
    
    //게시물 이미지 가져오기
    func getNoticeBoardImage(urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    self.bookImage = UIImage(data: imageData) ?? UIImage(named: "DefaultImage")!
                }
            }.resume()
        }
    }
    
    //예약자 명 가져오기
    func getReservationName(reservationId: String) {
        if reservationId != "" {
            let query = FirebaseManager.shared.firestore.collection("User").document(reservationId)
            
            query.getDocument { documentSnapshot, error in
                guard error == nil else { return }
                guard let document = documentSnapshot?.data() else { return }
                
                self.reservationName = document["nickname"] as? String ?? ""
            }
        }
    }
}

//MARK: newCount 초기화
extension ChatMessageViewModel {
    //채팅방 입장시 newCount 초기화
    func initNewCount(uid: String) {
        FirebaseManager.shared.firestore.collection("User").document(uid).collection("chatRoomList").document(saveChatRoomId).updateData([
            "newCount": 0
        ])
    }
}

//MARK: 메시지 전송 (Text)
extension ChatMessageViewModel {
    // 메시지 전송 저장 chatRoomListId가 있는 경우
    func handleSend(uid: String, partnerId: String) {
        let timestamp = Date()
        
        checkPartnerRoom(partnerId: partnerId, timestamp: timestamp, uid: uid) {
            let messageData = [
                "date": timestamp,
                "imageURL": "",
                "location": [100, 200],
                "message": self.chatText,
                "sender": uid
            ] as [String : Any]
            
            // 발신자용 메시지 전송 저장
            let myQuery = FirebaseManager.shared.firestore.collection("User")
                .document(uid)
                .collection("chatRoomList").document(self.saveChatRoomId)
            
            let senderDocument = myQuery.collection("messages").document()
            
            senderDocument.setData(messageData) { error in
                guard error == nil else { return }
                
                print("Successfully saved current user sending message")
                
                self.count += 1 // 채팅 화면 하단 갱신
            }
            
            myQuery.updateData([
                "date": timestamp,
                "recentMessage": self.chatText
            ])
            
            // 수신자용 메시지 전송 저장
            let partnerQuery = FirebaseManager.shared.firestore.collection("User").document(partnerId).collection("chatRoomList").document(self.saveChatRoomId)
            
            let recipientMessageDocument = partnerQuery.collection("messages").document()
            
            recipientMessageDocument.setData(messageData) { error in
                guard error == nil else { return }
                print("Recipient saved message as well")
            }
            
            partnerQuery.getDocument { documentSnapshot, error in
                guard error == nil else { return }
                guard let document = documentSnapshot else { return }
                
                partnerQuery.updateData([
                    "date": timestamp,
                    "newCount": (document.data()?["newCount"] as? Int ?? 0) + 1,
                    "recentMessage": self.chatText
                ])
                
                self.chatText = ""
            }
        }
    }
    
    // 메시지 전송 저장 chatRoomListId가 없는 경우
    func handleSendNoId(uid: String, partnerId: String, completion: () -> ()) {
        saveChatRoomId = UUID().uuidString
        
        let timestamp = Date()
        
        let query1 = FirebaseManager.shared.firestore.collection("User").document(uid).collection("chatRoomList").document(saveChatRoomId)
        
        query1.setData([
            "date": timestamp,
            "id": saveChatRoomId,
            "isAlarm": true,
            "newCount": 0,
            "noticeBoardId": noticeBoardInfo.id,
            "noticeBoardTitle": noticeBoardInfo.noticeBoardTitle,
            "partnerId": partnerId,
            "recentMessage": "",
            "userId": uid
        ])
        
        let query2 = FirebaseManager.shared.firestore.collection("User").document(partnerId).collection("chatRoomList").document(saveChatRoomId)
        
        query2.setData([
            "date": timestamp,
            "id": saveChatRoomId,
            "isAlarm": true,
            "newCount": 0,
            "noticeBoardId": noticeBoardInfo.id,
            "noticeBoardTitle": noticeBoardInfo.noticeBoardTitle,
            "partnerId": uid,
            "recentMessage": "",
            "userId": partnerId
        ])
        
        completion()
    }
    
    // 나갔다가 다시 보내는 경우(상대방이 chatId가 있음)
    func handleNoChatRoom(uid: String, partnerId: String, chatRoomListId: String, completion: () -> ()) {
        let timestamp = Date()
        
        let query1 = FirebaseManager.shared.firestore.collection("User").document(uid).collection("chatRoomList").document(chatRoomListId)
        
        query1.setData([
            "date": timestamp,
            "id": chatRoomListId,
            "isAlarm": true,
            "newCount": 0,
            "noticeBoardId": noticeBoardInfo.id,
            "noticeBoardTitle": noticeBoardInfo.noticeBoardTitle,
            "partnerId": partnerId,
            "recentMessage": "",
            "userId": uid
        ])
        
        completion()
    }
}

//MARK: 메시지 전송 (Image)
extension ChatMessageViewModel {
    func handleSendImage(uid: String, partnerId: String) {
        let timestamp = Date()
        
        checkPartnerRoom(partnerId: partnerId, timestamp: timestamp, uid: uid) {
            for image in self.selectedImages {
                self.nestedGroupImage.enter()
                
                self.saveImage(image: image) { urlString in
                    let messageData = [
                        "date": timestamp,
                        "imageURL": urlString,
                        "location": [100, 200],
                        "message": "",
                        "sender": uid
                    ] as [String : Any]
                    
                    
                    // 발신자용 메시지 전송 저장
                    let myQuery = FirebaseManager.shared.firestore.collection("User")
                        .document(uid)
                        .collection("chatRoomList").document(self.saveChatRoomId)
                    
                    let senderDocument = myQuery.collection("messages").document()
                    
                    senderDocument.setData(messageData) { error in
                        guard error == nil else { return }
                        
                        print("Successfully saved current user sending message")
                        
                        self.count += 1 // 채팅 화면 하단 갱신
                    }
                    
                    myQuery.updateData([
                        "date": timestamp,
                        "recentMessage": "사진"
                    ])
                    
                    // 수신자용 메시지 전송 저장
                    let partnerQuery = FirebaseManager.shared.firestore.collection("User").document(partnerId).collection("chatRoomList").document(self.saveChatRoomId)
                    
                    let recipientMessageDocument = partnerQuery.collection("messages").document()
                    
                    recipientMessageDocument.setData(messageData) { error in
                        guard error == nil else { return }
                        print("Recipient saved message as well")
                    }
                }
                self.nestedGroupImage.leave()
            }
            
            self.nestedGroup.notify(queue: .main) {
                let partnerQuery = FirebaseManager.shared.firestore.collection("User").document(partnerId).collection("chatRoomList").document(self.saveChatRoomId)
                
                partnerQuery.getDocument { documentSnapshot, error in
                    guard error == nil else { return }
                    guard let document = documentSnapshot else { return }
                    
                    
                    partnerQuery.updateData([
                        "date": timestamp,
                        "newCount": (document.data()?["newCount"] as? Int ?? 0) + self.selectedImages.count,
                        "recentMessage": "사진"
                    ])
                    
                    self.selectedImages.removeAll()
                }
            }
        }
    }
    
    //이미지 저장
    func saveImage(image: UIImage, completion: @escaping(String) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let ref = FirebaseManager.shared.storage.reference().child("ChatRoom/\(saveChatRoomId)/\(UUID().uuidString)")
        
        ref.putData(imageData, metadata: nil) { metadata, err in
            guard err == nil else { return }
            
            ref.downloadURL { url, error in
                guard error == nil else { return }
                guard let url = url else { return }
                
                completion(url.absoluteString)
            }
        }
    }
    
    //이미지 불러오기
    func getChatImage(urlString: String) {
        if !self.chatImages.contains(where: { $0.key == urlString }) {
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let imageData = data else { return }
                    
                    DispatchQueue.main.async {
                        self.chatImages.updateValue(UIImage(data: imageData) ?? UIImage(named: "DefaultImage")!, forKey: urlString)
                    }
                }.resume()
            }
        }
    }
}

//MARK: 메시지 전송 (위치)
extension ChatMessageViewModel {
    func handleSendLocation(uid: String, partnerId: String, lat: Double, lng: Double, location: String, completion: @escaping() -> ()) {
        let timestamp = Date()
        
        checkPartnerRoom(partnerId: partnerId, timestamp: timestamp, uid: uid) {
            let messageData = [
                "date": timestamp,
                "imageURL": "",
                "location": [lat, lng],
                "message": location,
                "sender": uid
            ] as [String : Any]
            
            // 발신자용 메시지 전송 저장
            let myQuery = FirebaseManager.shared.firestore.collection("User")
                .document(uid)
                .collection("chatRoomList").document(self.saveChatRoomId)
            
            let senderDocument = myQuery.collection("messages").document()
            
            senderDocument.setData(messageData) { error in
                guard error == nil else { return }
                
                print("Successfully saved current user sending message")
                
                self.count += 1 // 채팅 화면 하단 갱신
            }
            
            myQuery.updateData([
                "date": timestamp,
                "recentMessage": "위치"
            ])
            
            // 수신자용 메시지 전송 저장
            let partnerQuery = FirebaseManager.shared.firestore.collection("User").document(partnerId).collection("chatRoomList").document(self.saveChatRoomId)
            
            let recipientMessageDocument = partnerQuery.collection("messages").document()
            
            recipientMessageDocument.setData(messageData) { error in
                guard error == nil else { return }
                print("Recipient saved message as well")
            }
            
            partnerQuery.getDocument { documentSnapshot, error in
                guard error == nil else { return }
                guard let document = documentSnapshot else { return }
                
                partnerQuery.updateData([
                    "date": timestamp,
                    "newCount": (document.data()?["newCount"] as? Int ?? 0) + 1,
                    "recentMessage": "위치"
                ])
                
                self.chatText = ""
                
                completion()
            }
        }
    }
}

//MARK: 상대방이 채팅방 나갔는지 확인
extension ChatMessageViewModel {
    func checkPartnerRoom(partnerId: String, timestamp: Date, uid: String, completion: @escaping() -> ()) {
        FirebaseManager.shared.firestore.collection("User").document(partnerId).collection("chatRoomList").whereField("id", isEqualTo: saveChatRoomId).getDocuments { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot?.documents else { return }
            print(documents.count)
            if documents.count == 0 {
                let query2 = FirebaseManager.shared.firestore.collection("User").document(partnerId).collection("chatRoomList").document(self.saveChatRoomId)
                
                query2.setData([
                    "date": timestamp,
                    "id": self.saveChatRoomId,
                    "isAlarm": true,
                    "newCount": 0,
                    "noticeBoardId": self.noticeBoardInfo.id,
                    "noticeBoardTitle": self.noticeBoardInfo.noticeBoardTitle,
                    "partnerId": uid,
                    "recentMessage": "",
                    "userId": partnerId
                ])
            }
            completion()
        }
    }
}

//MARK: NoticeBoard 상태값 변경
extension ChatMessageViewModel {
    func changeState(state: Int, partnerId: String, noticeBoardId: String) {
        let partnerQuery = FirebaseManager.shared.firestore.collection("User").document(partnerId)
        let noticeQuery = FirebaseManager.shared.firestore.collection("noticeBoard").document(noticeBoardId)
        let myNoticeQuery = FirebaseManager.shared.firestore.collection("User").document(UserManager.shared.uid).collection("myNoticeBoard").document(noticeBoardId)
        
        partnerQuery.getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot?.data() else { return }
            
            var requests = document["requests"] as? [String] ?? []
            
            if state == 0 {
                if let index = requests.firstIndex(of: noticeBoardId) {
                    requests.remove(at: index)
                    
                    partnerQuery.updateData([
                        "requests": requests
                    ])
                    
                    noticeQuery.updateData([
                        "state": state,
                        "reservationId": ""
                    ])
                    
                    myNoticeQuery.updateData([
                        "state": state,
                        "reservationId": ""
                    ])
                    
                    self.noticeBoardInfo.reservationId = ""
                } else {
                    print("오류")
                }
            } else {
                if !requests.contains(noticeBoardId) {
                    requests.append(noticeBoardId)
                    
                    partnerQuery.updateData([
                        "requests": requests
                    ])
                }
                
                noticeQuery.updateData([
                    "state": state,
                    "reservationId": partnerId
                ])
                
                myNoticeQuery.updateData([
                    "state": state,
                    "reservationId": partnerId
                ])
                
                self.noticeBoardInfo.reservationId = partnerId
            }
        }
        self.noticeBoardInfo.state = state
    }
}

//MARK: 알림기능
extension ChatMessageViewModel {
    func changeAlarm(uid: String, isAlarm: Bool) {
        let myQuery = FirebaseManager.shared.firestore.collection("User")
            .document(uid)
            .collection("chatRoomList").document(saveChatRoomId)
        
        myQuery.updateData([
            "isAlarm": isAlarm ? false : true
        ])
    }
}

//MARK: 상대방에게 메세지 Push 알림
extension ChatMessageViewModel {
    
    func sendChatNotification(to partnerId: String, with message: String, chatRoomId: String) async {
        do {
            // 사용자 알림설정 체크
            let isChatEnabled = try await getChattingAlarmStatus(for: partnerId)
            // 각 채팅방 알림설정 체크
            let isChatRoomEnabled = try await getChatLoomAlarmStatus(for: partnerId, in: chatRoomId)
            
            if isChatEnabled && isChatRoomEnabled {
                // 사용자 알림 보내기 API
                await sendChatNotificationAPI(to: partnerId, withMessage: message, chatRoomId: chatRoomId)
                print("chatRoomId: \(chatRoomId)")
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    // 사용자 알림설정
    private func getChattingAlarmStatus(for partnerId: String) async throws -> Bool {
        let query = FirebaseManager.shared.firestore.collection("User").document(partnerId)
        let document = try await query.getDocument()
        return document.data()?["isChattingAlarm"] as? Bool ?? true
    }
    // 각 채팅방 알림설정
    private func getChatLoomAlarmStatus(for partnerId: String,in chatRoomId: String) async throws -> Bool {
        let query = FirebaseManager.shared.firestore.collection("User").document(partnerId).collection("chatRoomList").document(chatRoomId)
        let document = try await query.getDocument()
        return document.data()?["isAlarm"] as? Bool ?? true
    }
    
    private func sendChatNotificationAPI(to userId: String, withMessage message: String, chatRoomId: String) async {
        //Secrets.xcconfig파일 ServerURL 정보 불러오기
        guard let baseUrlString = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as? String else { return }
        
        let urlString = "http://\(baseUrlString)/send-notification"
        
        guard let url = URL(string: urlString) else {
            print("Invalid or missing URL")
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["userId": userId, "message": message, "chatRoomId": chatRoomId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("알림 전송 실패")
                return
            }
            print("알림 전송 성공")
        } catch {
            print("알림 전송 에러: \(error.localizedDescription)")
        }
    }
}

//MARK: 채팅방 나가기
extension ChatMessageViewModel {
    func deleteChatRoom(uid: String, partnerId: String, completion: @escaping() -> ()) {
        firestoreListener?.remove()
        
        FirebaseManager.shared.firestore.collection("User").document(partnerId).collection("chatRoomList").whereField("id", isEqualTo: self.saveChatRoomId).getDocuments { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot?.documents else { return }
            
            let messageRemoveQuery = FirebaseManager.shared.firestore.collection("User").document(uid).collection("chatRoomList").document(self.saveChatRoomId).collection("messages")
            
            //상대방도 채팅방이 없을 경우만 이미지 삭제
            if documents.isEmpty {
                messageRemoveQuery.getDocuments { querySnapshot, error in
                    guard error == nil else { return }
                    guard let documents = querySnapshot?.documents else { return }
                    
                    for document in documents {
                        guard let imageURL = document.data()["imageURL"] as? String else { return }
                        
                        if imageURL != "" {
                            self.deleteChatImages(imageURL: imageURL)
                        }
                        
                        messageRemoveQuery.document(document.documentID).delete()
                    }
                    
                    FirebaseManager.shared.firestore.collection("User").document(uid).collection("chatRoomList").document(self.saveChatRoomId).delete { _ in
                        
                        completion()
                    }
                }
            } else {
                messageRemoveQuery.getDocuments { querySnapshot, error in
                    guard error == nil else { return }
                    guard let documents = querySnapshot?.documents else { return }
                    
                    for document in documents {
                        messageRemoveQuery.document(document.documentID).delete()
                    }
                    
                    FirebaseManager.shared.firestore.collection("User").document(uid).collection("chatRoomList").document(self.saveChatRoomId).delete { _ in
                        
                        completion()
                    }
                }
            }
        }
    }
    
    //채팅 이미지 삭제
    func deleteChatImages(imageURL: String) {
        //상대방도 채팅방이 없을 경우만 삭제
        let ref = FirebaseManager.shared.storage.reference(forURL: imageURL)
        
        ref.delete { err in
            if err == nil {
                print("사진 삭제 성공")
            } else {
                print("사진 삭제 오류")
            }
        }
    }
    
    // 유저 차단
    
    
    func blockUser(userId: String) {
        // Firestore 인스턴스를 가져옵니다.
        let db = Firestore.firestore()
        let currentUserRef = db.collection("User").document(UserManager.shared.uid)
        let chatRoomsRef = currentUserRef.collection("chatRoomList")
        
        // 현재 사용자의 chatRoomList에서 partnerId가 차단 대상 사용자인 문서를 찾아 삭제합니다.
        chatRoomsRef.whereField("partnerId", isEqualTo: userId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            for document in snapshot.documents {
                // 채팅방 목록에서 차단된 사용자와의 채팅방 삭제
                chatRoomsRef.document(document.documentID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                
                // 선택사항: 채팅방에 포함된 메시지 및 이미지 데이터 삭제 처리
                // 채팅방 내 메시지와 관련된 추가 데이터 삭제 로직을 여기에 추가할 수 있습니다.
            }
        }
        
        
        
        
        
        currentUserRef.updateData([
            "blockUser": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                // 업데이트 실패
                print("Error updating document: \(error)")
            } else {
                // 업데이트 성공
                print("Document successfully updated")
            }
        }
    }
    
}
