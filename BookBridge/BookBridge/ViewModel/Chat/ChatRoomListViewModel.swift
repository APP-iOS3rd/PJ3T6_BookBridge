//
//  ChatListViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import Foundation
import FirebaseFirestore

class ChatRoomListViewModel: ObservableObject {
    
    @Published var chatRoomList: [ChatRoomListModel] = []
    @Published var chatRoomPartnerImages: [String] = []
    @Published var currentUser: UserModel?
    @Published var isLogout = false
    
    var firestoreListener: ListenerRegistration?
}

//MARK: 로그인 여부 확인
extension ChatRoomListViewModel {
    // 사용자 로그인 상태 확인
    func checkUserLoginStatus(uid: String) {
        if uid != "" {
            // 사용자가 로그인 상태인지 확인
            self.isLogout = false
            
            fetchCurrentUser(uid: uid)
        } else {
            //TODO: 우리 로그인창 띄우기
            // 사용자가 로그인되지 않은 상태인 경우 로그아웃 상태로 처리
            self.isLogout = true
            print("유저 정보 안옴")
        }
    }
    
    // 현재 사용자 데이터 가져오기
    func fetchCurrentUser(uid: String) {
        FirebaseManager.shared.firestore.collection("user").document(uid).getDocument { snapshot, error in
            guard error == nil else { return }
            guard let data = snapshot?.data() else { return }
            
            self.currentUser = UserModel(
                id: data["uid"] as? String ?? "",
                email: data["email"] as? String ?? "",
                profileURL: data["profileImageUrl"] as? String ?? ""
            )
            
            self.getChatRoomList(uid: uid) // 최근 메시지 가져오기
        }
    }
}

//MARK: 채팅방 리스트 관련
extension ChatRoomListViewModel {
    //채팅방 가져오기
    func getChatRoomList(uid: String) {
        // Firestore에서 최근 메시지를 가져오는 리스너 설정
        firestoreListener = FirebaseManager.shared.firestore.collection("user").document(uid).collection("chatRoomList").order(by: "date", descending: true).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot else { return }
            
            self.chatRoomList.removeAll()
            
            for document in documents.documents {
                guard let changeTime = document.data()["date"] as? Timestamp else { return }
                self.chatRoomList.append(ChatRoomListModel(
                    id: document.data()["id"] as? String ?? "",
                    userId: document.data()["userId"] as? String ?? "",
                    noticeBoardId: document.data()["noticeBoardId"] as? String ?? "",
                    partnerId: document.data()["partnerId"] as? String ?? "",
                    noticeBoardTitle: document.data()["noticeBoardTitle"] as? String ?? "",
                    recentMessage: document.data()["recentMessage"] as? String ?? "",
                    date: changeTime.dateValue(),
                    isAlarm: document.data()["isAlarm"] as? Bool ?? true,
                    newCount: document.data()["newCount"] as? Int ?? 0,
                    state: document.data()["state"] as? [Int] ?? [1, 0, 0]
                ))
                
                self.getPartnerImage(partnerId: document.data()["partnerId"] as? String ?? "")
            }
        }
    }
    
    // 채팅목록 삭제
    func deleteChatList(chatUserID: String) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // 채팅 데이터 삭제
        FirebaseManager.shared.firestore.collection("user")
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
    
    // 로그아웃 처리
    func doSignOut() {
        isLogout = true
        try? FirebaseManager.shared.auth.signOut()
    }
}

//MARK: 스토리지 관련
extension ChatRoomListViewModel {
    //상대방 프로필 이미지 가져오기
    func getPartnerImage(partnerId: String) {
        FirebaseManager.shared.firestore.collection("user").document("partnerId").getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            
            self.chatRoomPartnerImages.append(document.data()?["profileImageUrl"] as? String ?? "")
        }
    }
}
