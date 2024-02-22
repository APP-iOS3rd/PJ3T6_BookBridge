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
    @Published var noticeBoard: NoticeBoard = NoticeBoard(
        userId: "",
        noticeBoardTitle: "",
        noticeBoardDetail: "",
        noticeImageLink: [],
        noticeLocation: [],
        noticeLocationName: "교환장소 선택",
        isChange: false,
        state: 0,
        date: Date(),
        hopeBook: [],
        geoHash: "",
        reservationId: ""
    )
    @Published var markerCoord: NMGLatLng? //사용자가 저장 전에 마커 좌표변경을 할 경우 대비
    @Published var user: UserModel = UserModel()
    
    let nestedGroup = DispatchGroup()

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
extension PostingViewModel {
    func uploadPost(isChange: Bool, images: [UIImage]) {
        if isChange {                           //바꿔요일 경우 이미지 링크 생성(구해요는 빈 배열)
            // 이미지 ID 생성 및 storage에 이미지 저장
            for img in images {
                self.nestedGroup.enter()
                let imgName = UUID().uuidString
                uploadImage(image: img, name: (noticeBoard.id + "/" + imgName))
            }
        } else {
            // self.nestedGroup.leave()
        }
        
        let currentLat = UserManager.shared.user?.getSelectedLocation()?.lat ?? 0.0
        let currentLong = UserManager.shared.user?.getSelectedLocation()?.long ?? 0.0
        
        self.nestedGroup.notify(queue: .main) {
            // 게시물 정보 생성
            let post = NoticeBoard(
                id: self.noticeBoard.id,
                userId: UserManager.shared.uid,
                noticeBoardTitle: self.noticeBoard.noticeBoardTitle,
                noticeBoardDetail: self.noticeBoard.noticeBoardDetail,
                noticeImageLink: self.noticeBoard.noticeImageLink,
                noticeLocation: [currentLat, currentLong],
                noticeLocationName: UserManager.shared.currentDong,
                isChange: isChange,
                state: 0,
                date: Date(),
                hopeBook: self.noticeBoard.hopeBook,
                geoHash: GeohashManager.getGeoHash(lat: currentLat, long: currentLong),
                reservationId: ""
            )
            
            // 모든 게시물  noticeBoard/noticeBoardId/
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
}

//FirebaseStorage
extension PostingViewModel {
    func uploadImage(image: UIImage?, name: String) {
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
                
                self.nestedGroup.leave()
            }

        }
    }
}

extension PostingViewModel {
    func gettingUserInfo() {
        FirestoreManager.fetchUserLocation(uid: UserManager.shared.uid) { location1 in
            if let location = location1 {
                self.noticeBoard.noticeLocation = [location.first?.lat ?? 36, location.first?.long ?? 127]
                self.noticeBoard.noticeLocationName = location.first?.dong ?? "교환지역 선택"
                self.noticeBoard.geoHash = GeohashManager.getGeoHash(lat: location.first?.lat ?? 36, long: location.first?.long ?? 127)
            }
        }
    }
}
