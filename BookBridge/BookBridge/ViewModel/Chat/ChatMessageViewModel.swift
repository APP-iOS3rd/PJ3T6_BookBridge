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
    
    @Published var chatMessages: [ChatMessageModel] = []
    @Published var chatText = ""
    @Published var count = 0
    @Published var noticeBoardInfo: NoticeBoard = NoticeBoard(userId: "", noticeBoardTitle: "", noticeBoardDetail: "", noticeImageLink: [], noticeLocation: [], noticeLocationName: "", isChange: false, state: 0, date: Date(), hopeBook: [])
    
    var firestoreListener: ListenerRegistration?
    
    let nestedGroup = DispatchGroup()
    
    // 메시지 가져오기
    func fetchMessages(uid: String, chatRoomListId: String) {
        // 실시간 업데이트 감시
        firestoreListener = FirebaseManager.shared.firestore.collection("user").document(uid).collection("chatRoomList").document(chatRoomListId).collection("messages").order(by: "date", descending: false).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot else { return }
            
            self.chatMessages.removeAll()
            
            // 메시지 전송: 중복 x
            for document in documents.documents {
                guard let changeTime = document.data()["date"] as? Timestamp else { return }
                
                self.chatMessages.append(ChatMessageModel(
                    date: changeTime.dateValue() ,
                    imageURL: document.data()["imageURL"] as? String ?? "",
                    location: document.data()["location"] as? [String] ?? ["100", "200"],
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
            print("Sadsdadsa")
            
            if document.data()?["isChange"] as? Bool ?? true {          //바꿔요 게시물
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
                    hopeBook: []
                )
                
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
                            hopeBook: hopeBooks
                        )
                        
                        DispatchQueue.main.async {
                            self.noticeBoardInfo = noticeBoard
                        }
                    }
                }
            }
        }
    }
    
    // 메시지 전송 저장
    func handleSend(uid: String, partnerId: String, chatRoomListId: String) {
        let timestamp = Date()
        
        let messageData = [
            "date": timestamp,
            "imageURL": "",
            "location": ["100", "200"],
            "message": self.chatText,
            "sender": uid
        ] as [String : Any]
        
        
        // 발신자용 메시지 전송 저장
        let myQuery = FirebaseManager.shared.firestore.collection("user")
            .document(uid)
            .collection("chatRoomList").document(chatRoomListId)
        
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
        let partnerQuery = FirebaseManager.shared.firestore.collection("user").document(partnerId).collection("chatRoomList").document(chatRoomListId)
        
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
    
    //채팅방 입장시 newCount 초기화
    func initNewCount(uid: String, chatRoomId: String) {
        FirebaseManager.shared.firestore.collection("user").document(uid).collection("chatRoomList").document(chatRoomId).updateData([
            "newCount": 0
        ])
    }
}
