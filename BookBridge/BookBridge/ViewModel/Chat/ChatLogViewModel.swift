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
        firestoreListener = FirebaseManager.shared.firestore.collection("chatUsers")
            .document(fromId)
            .collection("messages")
            .document(toId)
            .collection("chatHistory")
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
                        self.chatMessages.append(ChatMessage(documentId: change.document.documentID, data: data))
                        print("Appending chatMessag in ChatLogView\(Date())")
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
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return } // 로그인계정
        
        guard let toId = chatUser?.uid else { return } // 채팅 상대방
        
        // 발신자용 메시지 전송 저장
        let senderDocument = FirebaseManager.shared.firestore.collection("chatUsers")
            .document(fromId)
            .collection("messages")
            .document(toId)
            .collection("chatHistory")
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
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("chatUsers")
            .document(toId)
            .collection("messages")
            .document(fromId)
            .collection("chatHistory")
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
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        // 발신자 최근 메시지 저장
        let document = FirebaseManager.shared.firestore.collection("chatUsers")
            .document(uid)
            .collection("recent_messages")
            .document(toId)
        
        // 발신자메시지 데이터
        let senderMessageData = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        document.setData(senderMessageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        // 수신자 메시지 데이터
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientMessageData = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // 수신자 최근 메시지 저장
        FirebaseManager.shared.firestore
            .collection("chatUsers")
            .document(toId)
            .collection("recent_messages")
            .document(currentUser.uid)
            .setData(recipientMessageData) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }

}
