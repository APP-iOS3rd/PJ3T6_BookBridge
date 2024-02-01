//
//  PostingViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 2/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class PostingViewModel: ObservableObject {
    @Published var noticeBoard: NoticeBoard = NoticeBoard(userId: "", noticeBoardTitle: "", noticeBoardDetail: "", noticeImageLink: [], noticeLocation: [], isChange: false, state: 0, date: Date())
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
}

//FireStore
extension PostingViewModel {
    func uploadPost(isChange: Bool, images: [UIImage]) {
        if isChange {                           //바꿔요일 경우 이미지 링크 생성(구해요는 빈 배열)
            // 이미지 ID 생성 및 storage에 이미지 저장
            for img in images {
                let imgName = UUID().uuidString
                noticeBoard.noticeImageLink.append(imgName)
                uploadImage(image: img, name: (noticeBoard.id + "/" + imgName))
            }
        }
        
        // 게시물 정보 생성
        let post = NoticeBoard(userId: "userId", noticeBoardTitle: noticeBoard.noticeBoardTitle, noticeBoardDetail: noticeBoard.noticeBoardDetail, noticeImageLink: noticeBoard.noticeImageLink, noticeLocation: [], isChange: true, state: 0, date: Date())
        
        // 모든 게시물  noticeBoard/noticeBoardId/
        let linkNoticeBoard = db.collection("noticeBoard").document(noticeBoard.id)
        
        linkNoticeBoard.setData(post.dictionary)
        
        // 내 게시물   user/userId/myNoticeBoard/noticeBoardId
        let user = db.collection("user").document("userId")
        
        user.collection("myNoticeBoard").document(noticeBoard.id).setData(post.dictionary)
        
    }
}

//FirebaseStorage
extension PostingViewModel {
    func uploadImage(image: UIImage?, name: String) {
        guard let imageData = image?.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        let storageRef = storage.reference().child("images/\(name)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // uploda data
        storageRef.putData(imageData, metadata: metadata) { (metadata, err) in
            if let err = err {
                print("err when uploading jpg\n\(err)")
            }
            
            if let metadata = metadata {
                print("metadata: \(metadata)")
            }
        }
    }
}
