//
//  PostModifyViewModel.swift
//  BookBridge
//
//  Created by jonghyun baik on 2/19/24.
//

import SwiftUI

import Foundation
import FirebaseFirestore
import FirebaseStorage
import NMapsMap

class PostModifyViewModel: ObservableObject {
    @Published var noticeBoard: NoticeBoard = NoticeBoard(userId: "", noticeBoardTitle: "", noticeBoardDetail: "", noticeImageLink: [], noticeLocation: [], noticeLocationName: "교환장소 선택", isChange: false, state: 0, date: Date(), hopeBook: [], geoHash: "")
    @Published var markerCoord: NMGLatLng? //사용자가 저장 전에 마커 좌표변경을 할 경우 대비
    @Published var user: UserModel = UserModel()
    var items: [Item] = []

    // 교환 장소 위도,경도
    func updateNoticeLocation(lat: Double?, lng: Double?){
        guard let lat = lat, let lng = lng else {return}
        
        if noticeBoard.noticeLocation.count >= 2 {
            noticeBoard.noticeLocation[0] = lat
            noticeBoard.noticeLocation[1] = lng
        }else{
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
extension PostModifyViewModel {
    func updatePost() {
        
        let linkNoticeBoard = db.collection("noticeBoard").document(noticeBoard.id)
        let user = db.collection("User").document(UserManager.shared.uid).collection("myNoticeBoard").document(noticeBoard.id)
        
        linkNoticeBoard.updateData(["noticeBoardTitle" : noticeBoard.noticeBoardTitle])
        linkNoticeBoard.updateData(["noticeBoardDetail" : noticeBoard.noticeBoardDetail])
        linkNoticeBoard.updateData(["noticeLocation" : noticeBoard.noticeLocation])
        linkNoticeBoard.updateData(["noticeLocationName" : noticeBoard.noticeLocationName])
        
        user.updateData(["noticeBoardTitle" : noticeBoard.noticeBoardTitle])
        user.updateData(["noticeBoardDetail" : noticeBoard.noticeBoardDetail])
        user.updateData(["noticeLocation" : noticeBoard.noticeLocation])
        user.updateData(["noticeLocationName" : noticeBoard.noticeLocationName])
        
        if !self.noticeBoard.isChange {
            for book in items {
                linkNoticeBoard.collection("hopeBooks").document(book.id).delete()
            }
        }
        
        if !self.noticeBoard.isChange && !self.noticeBoard.hopeBook.isEmpty {                      //구해요일 경우 희망 도서 정보 넣기
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
                
                if !(hopeBookInfo.industryIdentifiers?[0].identifier == nil) {
                    linkNoticeBoard.collection("hopeBooks").document(book.id).collection("industryIdentifiers").document(hopeBookInfo.industryIdentifiers?[0].identifier ?? "").setData([
                        "identifier": hopeBookInfo.industryIdentifiers?[0].identifier ?? ""
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
extension PostModifyViewModel {
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

extension PostModifyViewModel {
    func fetchNoticeBoardInfo (noticeBoard: NoticeBoard) {
        self.noticeBoard = noticeBoard
        
        if noticeBoard.isChange {
            
        } else {
            db.collection("noticeBoard").document(noticeBoard.id).collection("hopeBooks").getDocuments { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents, error == nil else {
                print("Error getting documents: \(error?.localizedDescription ?? "")")
                return
            }
            
            var items: [Item] = []
            for document in documents {
                let data = document.data()
                let volumeInfo = VolumeInfo(
                    title: data["title"] as? String,
                    authors: data["authors"] as? [String],
                    publisher: data["publisher"] as? String,
                    publishedDate: data["publishedDate"] as? String,
                    description: data["description"] as? String,
                    industryIdentifiers: [IndustryIdentifier(identifier: data["industryIdentifier"] as? String)],
                    pageCount: data["pageCount"] as? Int,
                    categories: data["categories"] as? [String],
                    imageLinks: ImageLinks(smallThumbnail: data["imageLinks"] as? String)
                )
                let item = Item(id: document.documentID, volumeInfo: volumeInfo)
                items.append(item)
            }
            
            DispatchQueue.main.async {
                self?.noticeBoard.hopeBook = items
                self?.items = items
            }
        }
        }
        
        print(noticeBoard)
    }
}
