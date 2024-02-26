//
//  FirestoreManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/8/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class FirestoreManager {
    static let db = Firestore.firestore()
    static let locationManager = LocationManager.shared
    
    
    
    // MARK: - Hopebook fetch
    static func fetchHopeBook(uid: String) async throws -> [Item]? {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("noticeBoard").document(uid).collection("hopeBooks").getDocuments()
        
        return snapshot.documents.compactMap { doc in
            let uid = doc.documentID
            let title = doc["title"] as? String ?? ""
            let authors = doc["authors"] as? [String] ?? []
            let publisher = doc["publisher"] as? String ?? ""
            let publishedDate = doc["publishedDate"] as? String ?? ""
            let description = doc["description"] as? String ?? ""
            let industryIdentifiers: [IndustryIdentifier] = []
            let pageCount = doc["pageCount"] as? Int ?? 0
            let categories = doc["categories"] as? [String] ?? []
            let imageLinks = doc["imageLinks"] as? String ?? ""
            
            let item = Item(
                id: uid,
                volumeInfo: VolumeInfo(
                    title: title,
                    authors: authors,
                    publisher: publisher,
                    publishedDate: publishedDate,
                    description: description,
                    industryIdentifiers: industryIdentifiers,
                    pageCount: pageCount,
                    categories: categories,
                    imageLinks: ImageLinks(smallThumbnail: imageLinks)
                )
            )
            
            return item
        }
    }
    
    // MARK: - FCM 토큰 업데이트
    static func updateFCMToken(forUser uid: String, completion: @escaping (Bool) -> Void) {
        FCMTokenManager.shared.fetchFCMToken { newToken in
            guard let fcmToken = newToken else {
                print("FCM 토큰 가져오기 실패")
                completion(false)
                return
            }
            
            // Firestore에서 사용자 문서를 찾아 FCM 토큰을 업데이트합니다.
            let userDocRef = db.collection("User").document(uid)
            userDocRef.updateData(["fcmToken": fcmToken]) { error in
                if let error = error {
                    print("FCM 토큰 업데이트 실패: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("FCM 토큰 업데이트 성공")
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - Location 불러오기(fetch)
    static func fetchUserLocation(uid: String, completion: @escaping ([Location]?) -> Void) {
            // 사용자의 uid를 이용하여 해당 사용자의 문서를 가져옵니다.
            let userDocRef = db.collection("User").document(uid)

            // 문서를 가져옵니다.
            userDocRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching user document: \(error)")
                    completion(nil)
                    return
                }

                // 문서가 존재하는 경우
                if let document = document, document.exists {
                    // 문서 데이터에서 location 필드만 가져옵니다.
                    if let userData = document.data(),
                       let locationData = userData["location"] as? [Any] {
                        do {
                            // location 데이터를 다시 JSON 데이터로 변환합니다.
                            let locationJsonData = try JSONSerialization.data(withJSONObject: locationData, options: [])
                            
                            // JSON 데이터를 사용하여 [Location]을 디코딩합니다.
                            let userLocations = try JSONDecoder().decode([Location].self, from: locationJsonData)
                            completion(userLocations)
                        } catch {
                            print("Error decoding User locations: \(error)")
                            completion(nil)
                        }
                    } else {
                        print("Error converting document location data to [Location]")
                        completion(nil)
                    }
                } else {
                    print("User document not found")
                    completion(nil)
                }
            }
        }
    
    // MARK: - User 불러오기(fetch)
    static func fetchUserModel(uid: String, completion: @escaping (UserModel?) -> Void) {
        // 사용자의 uid를 이용하여 해당 사용자의 문서를 가져옵니다.
        let userDocRef = db.collection("User").document(uid)
        
        // 문서를 가져옵니다.
        userDocRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                completion(nil)
                return
            }
            
            guard let stamp = document?.data()?["joinDate"] as? Timestamp else { return }
            
            fetchUserLocation(uid: uid) { locations in
                let User = UserModel(
                    id: document?.data()?["id"] as? String ?? "",
                    email: document?.data()?["email"] as? String ?? "",
                    loginId: document?.data()?["loginId"] as? String ?? "",
                    passsword: document?.data()?["passsword"] as? String ?? "",
                    nickname: document?.data()?["nickname"] as? String ?? "",
                    phoneNumber: document?.data()?["phoneNumber"] as? String ?? "",
                    profileURL: document?.data()?["profileURL"] as? String ?? "",
                    joinDate: stamp.dateValue(),
                    fcmToken: document?.data()?["fcmToken"] as? String ?? "",
                    location: locations,
                    bookMarks: document?.data()?["bookMarks"] as? [String] ?? [],
                    requests: document?.data()?["requests"] as? [String] ?? [],
                    style: document?.data()?["style"] as? String ?? "",
                    reviews: document?.data()?["reviews"] as? [Int] ?? [],
                    titles: document?.data()?["titles"] as? [String] ?? []
                )
                
                completion(User)
            }
        }
    }
    
    // MARK: - 불러오기(fetch)
    
    static func getLocations(completion: @escaping ([Location]) -> Void) {
        let docRef = getUserDoc(id: UserManager.shared.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let locationData = document.data()?["location"] as? [[String: Any]] {
                    let locations = locationsFromArray(locationData)
                    print("Location 변환 성공!")
                    completion(locations)
                    
                } else {
                    print("Location이 존재하지 않거나 형식이 올바르지 않습니다.")
                }
            } else {
                print("User documnet가 존재하지 않습니다.")
            }
        }
    }
    
    static func locationsFromArray(_ dataArray: [[String: Any]]) -> [Location] {
        var locations: [Location] = []
        for data in dataArray {
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                do {
                    let decoder = JSONDecoder()
                    let location = try decoder.decode(Location.self, from: jsonData)
                    locations.append(location)
                } catch {
                    print("Error decoding location data: \(error.localizedDescription)")
                }
            }
        }
        return locations
    }
    
    // MARK: - 저장(save)
    
    static func saveLocations(locations: [Location]) {
        let docRef = FirestoreManager.getUserDoc(id: UserManager.shared.uid)
        
        let locationData = locations.map { $0.dictionaryRepresentation }
        
        docRef.updateData([
            "location": locationData
        ]) { err in
            if let err = err {
                print(err)
                print("Location 저장에 실패하였습니다.")
            } else {
                print("Location 저장에 성공하였습니다.")
            }
        }
    }
    
    static func saveSelectedLocation() {
        
    }
    
    // MARK: - 기타
    
    // Location 생성
    static func makeLocationByCurLocation() -> Location {
        return Location(
            id: UUID().uuidString,
            lat: locationManager.lat,
            long: locationManager.long,
            city: locationManager.city,
            distriction: locationManager.distriction,
            dong: locationManager.dong, distance: 1
        )
    }
    
    // User documnet 가져오기
    static func getUserDoc(id: String) -> DocumentReference  {
        return db.collection("User").document(id)
    }
    
    static func deleteUserData(uid: String, completion: @escaping (Bool) -> Void) {
        // Firestore에서 사용자 데이터를 삭제하는 로직 구현
        // 예시: 사용자 프로필, 게시글, 댓글 등
        let userDocRef = db.collection("User").document(uid)
        let userPostRef = db.collection("noticeBoard").whereField("userId", isEqualTo: uid)
        
        
        // 사용자 문서 삭제
        userDocRef.delete { error in
            if let error = error {
                print("사용자 문서 삭제 실패: \(error.localizedDescription)")
                completion(false)
            } else {
                print("사용자 문서 삭제 성공")
                completion(true)
            }
        }
        
        // 사용자 게시물 삭제
        userPostRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(false)
                return
            } else {
                for document in querySnapshot!.documents {
                    let noticeBoardId = document.documentID
                    
                    // firestore 문서 삭제
                    document.reference.delete()
                    
                    // 스토리지 이미지 삭제
                    deleteUserPostImages(noticeBoardId: noticeBoardId)
                }
                completion(true)
            }
            
            
        }
        
    }
    
    static func deleteUserProfileImage(uid: String, completion: @escaping (Bool) -> Void) {
        let storageRef = FirebaseStorage.Storage.storage().reference()
        let userProfileImageRef = storageRef.child("User/\(uid)")

        // 사용자 프로필 이미지 삭제
        userProfileImageRef.delete { error in
            if let error = error {
                print("프로필 이미지 삭제 실패: \(error.localizedDescription)")
                completion(false)
            } else {
                print("프로필 이미지 삭제 성공")
                completion(true)
            }
        }
    }
    
    static func deleteUserPostImages(noticeBoardId: String) {
        let storageRef = FirebaseStorage.Storage.storage().reference()
        let postImageFolderRef = storageRef.child("NoticeBoard/\(noticeBoardId)")

        postImageFolderRef.listAll { (result, error) in
            if let error = error {
                print("Error listing files: \(error)")
                return
            }

            for item in result!.items {
                item.delete { error in
                    if let error = error {
                        print("Error deleting file: \(error)")
                    } else {
                        print("File successfully deleted: \(item.name)")
                    }
                }
            }
        }
    }

}

