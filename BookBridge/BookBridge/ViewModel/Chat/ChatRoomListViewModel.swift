//
//  ChatListViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import Foundation
import FirebaseFirestore

class ChatRoomListViewModel: ObservableObject {
    
    @Published var chatRoomDic: [String: ChatPartnerModel] = [:]
    @Published var chatRoomList: [ChatRoomListModel] = []
    @Published var isLogout = false
    @Published var searchText: String = ""
    
    var firestoreListener: ListenerRegistration?
    
    let nestedGroup = DispatchGroup()
}

//MARK: 채팅방 검색
extension ChatRoomListViewModel {
    func searchChatRoomList() -> [ChatRoomListModel] {
        if self.searchText == "" {
            return chatRoomList
        } else {
            return chatRoomList.filter { $0.noticeBoardTitle.contains(searchText) }
        }
    }
}

//MARK: 로그인 여부 확인
extension ChatRoomListViewModel {
    // 사용자 로그인 상태 확인
    func checkUserLoginStatus(uid: String, isComeNoticeBoard: Bool, chatRoomListStr: [String]) {
        if uid != "" {
            // 사용자가 로그인 상태인지 확인
            self.isLogout = false
            
            self.getChatRoomList(uid: uid, isComeNoticeBoard: isComeNoticeBoard, chatRoomListStr: chatRoomListStr) // 채팅방 리스트 가져오기
        } else {
            //TODO: 우리 로그인창 띄우기
            // 사용자가 로그인되지 않은 상태인 경우 로그아웃 상태로 처리
            self.isLogout = true
            print("유저 정보 안옴")
        }
    }
}

//MARK: 채팅방 리스트 관련
extension ChatRoomListViewModel {
    //채팅방 가져오기
    func getChatRoomList(uid: String, isComeNoticeBoard: Bool, chatRoomListStr: [String]) {
        self.firestoreListener?.remove()
        // Firestore에서 최근 메시지를 가져오는 리스너 설정
        firestoreListener = FirebaseManager.shared.firestore.collection("User").document(uid).collection("chatRoomList").order(by: "date", descending: true).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return }
            guard let documents = querySnapshot?.documents else { return }
            
            self.chatRoomList.removeAll()

            for document in documents {
                self.nestedGroup.enter()
                
                guard let changeTime = document.data()["date"] as? Timestamp else { return }
                guard let partnerId = document.data()["partnerId"] as? String else { return }
                guard let noticeBoardId = document.data()["noticeBoardId"] as? String else { return }
                
                if isComeNoticeBoard {
                    if chatRoomListStr.contains(document.documentID) {
                        self.chatRoomList.append(ChatRoomListModel(
                            id: document.data()["id"] as? String ?? "",
                            userId: document.data()["userId"] as? String ?? "",
                            noticeBoardId: noticeBoardId,
                            partnerId: partnerId,
                            noticeBoardTitle: document.data()["noticeBoardTitle"] as? String ?? "",
                            recentMessage: document.data()["recentMessage"] as? String ?? "",
                            date: changeTime.dateValue(),
                            isAlarm: document.data()["isAlarm"] as? Bool ?? true,
                            newCount: document.data()["newCount"] as? Int ?? 0
                        ))
                        
                        self.getPartnerImage(partnerId: partnerId, noticeBoardId: noticeBoardId, chatRoomListId: document.data()["id"] as? String ?? "")
                    }
                } else {
                    self.chatRoomList.append(ChatRoomListModel(
                        id: document.data()["id"] as? String ?? "",
                        userId: document.data()["userId"] as? String ?? "",
                        noticeBoardId: noticeBoardId,
                        partnerId: partnerId,
                        noticeBoardTitle: document.data()["noticeBoardTitle"] as? String ?? "",
                        recentMessage: document.data()["recentMessage"] as? String ?? "",
                        date: changeTime.dateValue(),
                        isAlarm: document.data()["isAlarm"] as? Bool ?? true,
                        newCount: document.data()["newCount"] as? Int ?? 0
                    ))
                    
                    self.getPartnerImage(partnerId: partnerId, noticeBoardId: noticeBoardId, chatRoomListId: document.data()["id"] as? String ?? "")
                }
            }
        }
    }
}

//MARK: 상대방 이미지 관련
extension ChatRoomListViewModel {
    //상대방 프로필 이미지 가져오기
    func getPartnerImage(partnerId: String, noticeBoardId: String, chatRoomListId: String) {
        FirebaseManager.shared.firestore.collection("User").document(partnerId).getDocument { documentSnapshot, error in
            guard error == nil else { return }
            guard let document = documentSnapshot else { return }
            guard let urlString = document.data()?["profileURL"] as? String else { return }
            guard let nickname = document.data()?["nickname"] as? String else { return }
            guard let style = document.data()?["style"] as? String else { return }
            
            //TODO: 여기서 상대방 이름, 칭호 등 가져오기
            if !self.chatRoomDic.contains(where: { $0.key == chatRoomListId }){
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        guard let imageData = data else { return }
                        
                        DispatchQueue.main.async {
                            self.chatRoomDic.updateValue(ChatPartnerModel(nickname: nickname, noticeBoardId: noticeBoardId, partnerId: partnerId, partnerImage: UIImage(data: imageData) ?? UIImage(named: "DefaultImage")!, style: style), forKey: chatRoomListId)
                        }
                    }.resume()
                }
            }
            self.nestedGroup.leave()
        }
    }
}
