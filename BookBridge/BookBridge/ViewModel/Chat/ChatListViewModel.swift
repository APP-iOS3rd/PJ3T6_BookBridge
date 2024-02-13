//
//  ChatListViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import Foundation
import FirebaseFirestore

class ChatListViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var recentMessages = [RecentMessage]()
    
    private var firestoreListener: ListenerRegistration?
    
    // 초기화 시 로그아웃 상태 확인
    init() {
        checkUserLoginStatus()
    }
    
    // 사용자 로그인 상태 확인
    func checkUserLoginStatus() {
        if let currentUser = FirebaseManager.shared.auth.currentUser {
            // 사용자가 로그인 상태인지 확인
            isUserCurrentlyLoggedOut = false
            
            // 사용자 정보 가져오기
            FirebaseManager.shared.firestore.collection("chatUsers")
                .document(currentUser.uid)
                .getDocument { snapshot, error in
                    if let error = error {
                        print("유저 정보 가져오기 실패:", error)
                        self.errorMessage = "유저 정보 가져오기 실패: \(error.localizedDescription)"
                        // 사용자 정보 가져오기에 실패한 경우 로그아웃 상태로 처리
                        self.isUserCurrentlyLoggedOut = true
                        return
                    }
                    
                    guard let data = snapshot?.data() else {
                        print("현재 사용자에 대한 데이터를 찾을 수 없음")
                        self.errorMessage = "현재 사용자에 대한 데이터를 찾을 수 없음"
                        // 사용자 정보가 없는 경우 로그아웃 상태로 처리
                        self.isUserCurrentlyLoggedOut = true
                        return
                    }
                    
                    // 사용자 정보가 있는 경우 해당 정보를 업데이트
                    self.chatUser = .init(data: data)
                    
                    // 최근 메시지 가져오기
                    self.fetchRecentMessages() // 최근 메시지 가져오기
                }
        } else {
            // 사용자가 로그인되지 않은 상태인 경우 로그아웃 상태로 처리
            isUserCurrentlyLoggedOut = true
        }
    }
    
    // 현재 사용자 데이터 가져오기
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("chatUsers")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch current user: \(error)"
                    print("Failed to fetch current user:", error)
                    return
                }
                
                guard let data = snapshot?.data() else {
                    self.errorMessage = "No data found"
                    return
                }
                
                self.chatUser = .init(data: data)
            }
    }
    
    // 최근 메시지 가져오기
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // Firestore 리스너 제거 및 최근 메시지 배열 초기화
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        
        // Firestore에서 최근 메시지를 가져오는 리스너 설정
        firestoreListener = FirebaseManager.shared.firestore
            .collection("chatUsers")
            .document(uid)
            .collection("recent_messages")
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                // 최근 메세지 업데이트
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    // 이미 존재하는 최근 메시지가 있다면 제거
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    // 새로운 최근 메시지를 목록 맨 위에 추가
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                })
            }
    }
    
    // 채팅목록 삭제
    func deleteChatList(chatUserID: String) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // 채팅 데이터 삭제
        FirebaseManager.shared.firestore.collection("chatUsers")
            .document(uid)
            .collection("messages")
            .document(chatUserID)
            .delete { error in
                if let error = error {
                    print("Failed to delete chat data: \(error)")
                    return
                }
                print("Successfully deleted chat data")
            }
        
        // 최근 메시지 삭제
        FirebaseManager.shared.firestore.collection("chatUsers")
            .document(uid)
            .collection("recent_messages")
            .document(chatUserID)
            .delete { error in
                if let error = error {
                    print("Failed to delete recent message: \(error)")
                    return
                }
                
                print("Successfully deleted recent message")
            }
    }
    
//    // 새 메세지 갱신
//    func listenForNewMessages() {
//        guard let currentUserID = FirebaseManager.shared.currentUser?.uid else {
//            print("Failed to listen for new messages: Current user not found")
//            return
//        }
//
//        firestoreListener = FirebaseManager.shared.firestore.collection("chatUsers")
//            .document(currentUserID)
//            .collection("recent_messages")
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    print("Failed to listen for new messages: \(error)")
//                    return
//                }
//
//                // 새로운 메시지가 도착하면 최근 메시지 목록 갱신
//                self.fetchRecentMessages()
//            }
//    }
    
    // 로그아웃 처리
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}
