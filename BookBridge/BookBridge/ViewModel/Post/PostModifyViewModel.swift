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
    
    let nestedGroup = DispatchGroup()
    let dispatchGroup = DispatchGroup()
    
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
    func updatePost(images: [UIImage]) {
        
        let linkNoticeBoard = db.collection("noticeBoard").document(noticeBoard.id)
        let user = db.collection("User").document(UserManager.shared.uid).collection("myNoticeBoard").document(noticeBoard.id)
        
        linkNoticeBoard.updateData([
            "noticeBoardTitle" : noticeBoard.noticeBoardTitle,
            "noticeBoardDetail" : noticeBoard.noticeBoardDetail,
            "noticeLocation" : noticeBoard.noticeLocation,
            "noticeLocationName" : noticeBoard.noticeLocationName
        ])
        
        user.updateData([
            "noticeBoardTitle" : noticeBoard.noticeBoardTitle,
            "noticeBoardDetail" : noticeBoard.noticeBoardDetail,
            "noticeLocation" : noticeBoard.noticeLocation,
            "noticeLocationName" : noticeBoard.noticeLocationName
        ])
        
        if !self.noticeBoard.isChange {
            for book in items {
                linkNoticeBoard.collection("hopeBooks").document(book.id).collection("industryIdentifiers").document(book.volumeInfo.industryIdentifiers?[0].identifier ?? "").delete()
                user.collection("hopeBooks").document(book.id).collection("industryIdentifiers").document(book.volumeInfo.industryIdentifiers?[0].identifier ?? "").delete()
                
                linkNoticeBoard.collection("hopeBooks").document(book.id).delete()
                user.collection("hopeBooks").document(book.id).delete()
            }
        } else {
            deleteFolder(folderPath: "NoticeBoard/\(noticeBoard.id)")
            noticeBoard.noticeImageLink = []
            // 이미지 ID 생성 및 storage에 이미지 저장
            for img in images {
                dispatchGroup.enter()
                let imgName = UUID().uuidString
                uploadImage(image: img, name: (noticeBoard.id + "/" + imgName)) {
                    // 이미지 업로드가 완료되면 실행될 클로저
                    self.dispatchGroup.leave() // 작업이 완료되었음을 dispatchGroup에 알림
                }
            }
            dispatchGroup.notify(queue: .main) {
                // 모든 이미지 업로드가 완료된 후에 실행될 코드
                linkNoticeBoard.updateData(["noticeImageLink" : self.noticeBoard.noticeImageLink])
                user.updateData(["noticeImageLink" : self.noticeBoard.noticeImageLink])
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
                
                user.collection("hopeBooks").document(book.id).setData([
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
                    
                    user.collection("hopeBooks").document(book.id).collection("industryIdentifiers").document(hopeBookInfo.industryIdentifiers?[0].identifier ?? "").setData([
                        "identifier": hopeBookInfo.industryIdentifiers?[0].identifier ?? ""
                    ])
                }
            }
        }
    }
}

//FirebaseStorage
extension PostModifyViewModel {
    
    func uploadImage(image: UIImage?, name: String, completion: @escaping () -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        let storageRef = storage.reference().child("NoticeBoard/\(name)")
        // uploda data
        storageRef.putData(imageData, metadata: nil) { (metadata, err) in
            guard err == nil else { return }
            
            storageRef.downloadURL { url, error in
                guard error == nil else { return }
                guard let url = url else { return }
                
                self.noticeBoard.noticeImageLink.append(url.absoluteString)
                completion()
            }
            
        }
    }
}

extension PostModifyViewModel {
    func fetchNoticeBoardInfo (noticeBoard: NoticeBoard) {
        self.noticeBoard = noticeBoard
        
        if noticeBoard.isChange {
            
        } else {
            db.collection("noticeBoard").document(noticeBoard.id).collection("hopeBooks").getDocuments { querySnapshot2, err2 in
                guard err2 == nil else { return }
                guard let hopeDocuments = querySnapshot2?.documents else { return }
                
                var hopeBooks: [Item] = []
                
                for doc in hopeDocuments {
                    if doc.exists {
                        self.nestedGroup.enter() // Enter nested DispatchGroup
                        
                        self.db.collection("noticeBoard").document(noticeBoard.id).collection("hopeBooks").document(doc.documentID).collection("industryIdentifiers").getDocuments { (querySnapshot, error) in
                            guard let industryIdentifiers = querySnapshot?.documents else {
                                self.nestedGroup.leave()
                                return
                            }
                            
                            var isbn: [IndustryIdentifier] = []
                            for industryIdentifier in industryIdentifiers {
                                isbn.append(IndustryIdentifier(identifier: industryIdentifier.documentID))
                            }
                            
                            let item = Item(id: doc.documentID, volumeInfo: VolumeInfo(
                                title: doc.data()["title"] as? String ?? "",
                                authors: (doc.data()["authors"] as? [String] ?? [""]),
                                publisher: doc.data()["publisher"] as? String ?? "",
                                publishedDate: doc.data()["publishedDate"] as? String ?? "",
                                description: doc.data()["description"] as? String ?? "",
                                industryIdentifiers: isbn,
                                pageCount: doc.data()["pageCount"] as? Int ?? 0,
                                categories: doc.data()["categories"] as? [String] ?? [""],
                                imageLinks: ImageLinks(smallThumbnail: doc.data()["imageLinks"] as? String ?? "")))
                            
                            hopeBooks.append(item)
                            
                            self.nestedGroup.leave() // Leave nested DispatchGroup
                        }
                    } else {
                        self.nestedGroup.leave() // Leave nested DispatchGroup
                    }
                }
                self.nestedGroup.notify(queue: .main) {
                    DispatchQueue.main.async {
                        self.noticeBoard.hopeBook = hopeBooks
                        self.items = hopeBooks
                    }
                }
            }
        }
        print(noticeBoard)
    }
    
    func urlToUIImage(completion: @escaping ([UIImage]?) -> Void) {
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for image in noticeBoard.noticeImageLink {
            if let url = URL(string: image) {
                dispatchGroup.enter() // 작업 진입을 알림
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    defer {
                        dispatchGroup.leave() // 작업 완료 후 dispatchGroup에서 빠져나옴
                    }
                    
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
                    
                    if let data = data, let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                }.resume()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images)
        }
    }
    
    
    func deleteFolder(folderPath: String) {
        let storageRef = Storage.storage().reference().child(folderPath)
        
        // 폴더 내의 모든 파일(이미지) 삭제
        storageRef.listAll { (result, error) in
            // result가 nil이 아닐 때만 진행
            guard let result = result else {
                print("Error: result is nil")
                return
            }
            
            if let error = error {
                // 에러 처리
                print("Error listing files: \(error)")
                return
            }
            
            // 각 파일을 순회하며 삭제
            for item in result.items {
                item.delete { error in
                    if let error = error {
                        // 에러 처리
                        print("Error deleting file: \(error)")
                    } else {
                        // 성공적으로 삭제됨
                        print("File successfully deleted: \(item.name)")
                    }
                }
            }
        }
    }
}

extension PostModifyViewModel {
    func fetchMarkerById(noticeBoardId: String) {
        let db = Firestore.firestore()
        db.collection("noticeBoard").document(noticeBoardId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let noticeBoard = NoticeBoard(
                    id: document.documentID,
                    userId: data?["userId"] as? String ?? "",
                    noticeBoardTitle: data?["noticeBoardTitle"] as? String ?? "",
                    noticeBoardDetail: data?["noticeBoardDetail"] as? String ?? "",
                    noticeImageLink: data?["noticeImageLink"] as? [String] ?? [],
                    noticeLocation: data?["noticeLocation"] as? [Double] ?? [0.0, 0.0],
                    noticeLocationName: data?["noticeLocationName"] as? String ?? "",
                    isChange: data?["isChange"] as? Bool ?? false,
                    state: data?["state"] as? Int ?? 0,
                    date: (data?["date"] as? Timestamp)?.dateValue() ?? Date(),
                    hopeBook: [], // hopeBook은
                    geoHash: data?["geoHash"] as? String,
                    reservationId: data?["reservationId"] as? String
                )
                
                self.markerCoord = NMGLatLng(lat: noticeBoard.noticeLocation[0], lng: noticeBoard.noticeLocation[1])
                
            } else {
                print("noticeBoard Document does not exist")
            }
        }
    }
}
