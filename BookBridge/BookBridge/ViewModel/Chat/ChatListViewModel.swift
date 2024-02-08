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
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        // 현재 사용자 정보 호출
        fetchCurrentUser()
        // 최근 메시지 호출
        fetchRecentMessages()
    }
    
    // 최근 메시지 가져오기
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // Firestore 리스너 제거 및 최근 메시지 배열 초기화
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        
        // Firestore에서 최근 메시지를 가져오는 리스너 설정
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
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
    
    // 현재 사용자 불러오기
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("ChatUsers")
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
    
    // 로그아웃 처리
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}
