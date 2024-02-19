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
    }
}
