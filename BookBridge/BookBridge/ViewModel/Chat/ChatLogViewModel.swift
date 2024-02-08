//
//  ChatLogViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0
    
    var chatUser: ChatUser?
    
    var firestoreListener: ListenerRegistration?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    // 메시지 가져오기
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore.collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp)   // 채팅 메시지 오름차순 정렬
            .addSnapshotListener { querySnapshot, error in   // 실시간 업데이트 감시
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                // 메시지 전송: 중복 x
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                
                // 자동 스크롤 비동기
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    // 메시지 전송 저장
    func handleSend(text: String) {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        // 발신자용 메시지 전송 저장
        let senderDocument = FirebaseManager.shared.firestore.collection("messages") // messages 메인컬렉션 저장
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.timestamp: Timestamp()
        ] as [String : Any]
        
        senderDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1 // 채팅 화면 하단 갱신
        }
        
        // 수신자용 메시지 전송 저장
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
    }
    
    // 채팅목록 최근 메세지 저장
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        // 발신자와 수신자의 데이터
        let rmData = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String: Any]
        
        // 발신자의 최근 메시지 저장
        let senderRmDocument = FirebaseManager.shared.firestore.collection(FirebaseConstants.recentMessages)
            .document(fromId) // 로그인 계정
            .collection(FirebaseConstants.messages) // 서브컬렉션 messages 생성
            .document(toId) // 메시지 수신자 계정 정보
        
        senderRmDocument.setData(rmData) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        // 수신자 최근 메시지 저장
        let recipientRmDocument = FirebaseManager.shared.firestore.collection(FirebaseConstants.recentMessages)
            .document(toId) // 로그인 계정
            .collection(FirebaseConstants.messages) // 서브컬렉션 messages 생성
            .document(fromId) // 메시지 수신자 계정 정보
        
        recipientRmDocument.setData(rmData) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message for recipient: \(error)"
                print("Failed to save recent message for recipient: \(error)")
                return
            }
        }
    }
}
