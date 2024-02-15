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
    
    var firestoreListener: ListenerRegistration?
    
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
            
            self.chatText = ""
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
        }
    }
    
    //채팅방 입장시 newCount 초기화
    func initNewCount(uid: String, chatRoomId: String) {
        FirebaseManager.shared.firestore.collection("user").document(uid).collection("chatRoomList").document(chatRoomId).updateData([
            "newCount": 0
        ])
    }
}
