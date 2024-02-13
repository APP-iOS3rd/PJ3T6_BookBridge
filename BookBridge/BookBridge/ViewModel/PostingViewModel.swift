//
//  PostingViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 2/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import NMapsMap

class PostingViewModel: ObservableObject {
    @Published var noticeBoard: NoticeBoard = NoticeBoard(userId: "", noticeBoardTitle: "", noticeBoardDetail: "", noticeImageLink: [], noticeLocation: [],noticeLocationName: "교환장소 선택", isChange: false, state: 0, date: Date(), hopeBook: [], geohash: "")
    @Published var markerCoord: NMGLatLng? //사용자가 저장 전에 마커 좌표변경을 할 경우 대비

    // 교환 장소 위도,경도
    func updateNoticeLocation(lat: Double?, lng: Double?){
        guard let lat = lat, let lng = lng else { return }
        
        if noticeBoard.noticeLocation.count >= 2 {
            noticeBoard.noticeLocation[0] = lat
            noticeBoard.noticeLocation[1] = lng
        } else {
            noticeBoard.noticeLocation = [lat, lng]
        }
    }
    
    // 교환 장소 도로명
    func updateNoticeLocationName(name: String) {
        noticeBoard.noticeLocationName = name
    }
    
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
                        
        FirestoreManager.fetchUserModel{ userModel in
            let post = NoticeBoard(
                id: self.noticeBoard.id,
                userId: UserManager.shared.uid,
                noticeBoardTitle: self.noticeBoard.noticeBoardTitle,
                noticeBoardDetail: self.noticeBoard.noticeBoardDetail,
                noticeImageLink: self.noticeBoard.noticeImageLink,
                noticeLocation: self.noticeBoard.noticeLocation,
                noticeLocationName: self.noticeBoard.noticeLocationName,
                isChange: isChange,
                state: 0,
                date: Date(), hopeBook: self.noticeBoard.hopeBook,
                geohash: userModel?.getSelectedLocation()?.geohash ?? ""
            )
            
            let linkNoticeBoard = self.db.collection("noticeBoard").document(self.noticeBoard.id)
            
            linkNoticeBoard.setData(post.dictionary)
            
            // 내 게시물   user/userId/myNoticeBoard/noticeBoardId
            let user = self.db.collection("User").document(UserManager.shared.uid)
            
            user.collection("myNoticeBoard").document(self.noticeBoard.id).setData(post.dictionary)
            
            if !isChange && !self.noticeBoard.hopeBook.isEmpty{                      //구해요일 경우 희망 도서 정보 넣기
                for book in self.noticeBoard.hopeBook {
                    let hopeBookInfo = book.volumeInfo
                    linkNoticeBoard.collection("hopeBooks").document(book.id).setData([
                        "title": hopeBookInfo.title ?? "제목 미상",
                        "authors": hopeBookInfo.authors ?? ["저자 미상"],
                        "publisher": hopeBookInfo.publisher ?? "출판사 미상",
                        "publishedDate": hopeBookInfo.publishedDate ?? "출판 날짜 미상",
                        "description": hopeBookInfo.description ??  "설명이 없어요..",
                        "pageCount": hopeBookInfo.pageCount ?? 0,
                        "categories": hopeBookInfo.categories ?? ["장르 미상"],
                        "imageLinks": hopeBookInfo.imageLinks?.smallThumbnail ?? ""
                    ])
                    
                    linkNoticeBoard.collection("hopeBooks").document(book.id).collection("industryIdentifiers").document(hopeBookInfo.industryIdentifiers?[0].identifier ?? "").setData([
                        "identifier": hopeBookInfo.industryIdentifiers?[0].identifier ?? ""
                    ])
                    
                    user.collection("myNoticeBoard").document(self.noticeBoard.id).collection("hopeBooks").document(book.id).setData([
                        "title": hopeBookInfo.title ?? "제목 미상",
                        "authors": hopeBookInfo.authors ?? ["저자 미상"],
                        "publisher": hopeBookInfo.publisher ?? "출판사 미상",
                        "publishedDate": hopeBookInfo.publishedDate ?? "출판 날짜 미상",
                        "description": hopeBookInfo.description ??  "설명이 없어요..",
                        "pageCount": hopeBookInfo.pageCount ?? 0,
                        "categories": hopeBookInfo.categories ?? ["장르 미상"],
                        "imageLinks": hopeBookInfo.imageLinks?.smallThumbnail ?? ""
                    ])
                    
                    user.collection("myNoticeBoard").document(self.noticeBoard.id).collection("hopeBooks").document(book.id).collection("industryIdentifiers").document(hopeBookInfo.industryIdentifiers?[0].identifier ?? "").setData([
                        "identifier": hopeBookInfo.industryIdentifiers?[0].identifier ?? ""
                    ])
                }
            }
        }
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
