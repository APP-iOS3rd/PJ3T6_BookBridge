//
//  FirestoreManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/8/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreManager {
    static let db = Firestore.firestore()
    static let locationManager = LocationManager.shared
    
    // MARK: - User 불러오기(fetch)
    static func fetchUserModel(completion: @escaping (UserModel?) -> Void) {
        // 사용자의 uid를 이용하여 해당 사용자의 문서를 가져옵니다.
        let userDocRef = db.collection("User").document(UserManager.shared.uid)

        // 문서를 가져옵니다.
        userDocRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                completion(nil)
                return
            }

            // 문서가 존재하는 경우
            if let document = document, document.exists {
                // 문서 데이터를 UserModel로 변환합니다.
                if let userData = document.data() {
                    do {
                        // JSON 데이터로 변환합니다.
                        let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
                        
                        // JSON 데이터를 사용하여 UserModel을 디코딩합니다.
                        let userModel = try JSONDecoder().decode(UserModel.self, from: jsonData)
                        completion(userModel)
                    } catch {
                        print("Error decoding UserModel: \(error)")
                        completion(nil)
                    }
                } else {
                    print("Error converting document data to UserModel")
                    completion(nil)
                }
            } else {
                print("User document not found")
                completion(nil)
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
                    

    
// MARK: - 수정(update)
            
    static func saveLocationDistance(id: String, locations: [Location], circleRadius: Int) {
        var targetLocations = locations
        
        // index 찾기
        guard let index = getIndexWithId(value: locations, id: id) else { return }
        
        // 변경된 distance값 가져오기
        let targetDistance = ConvertManager.changeKilometerToDistance(value: Int(circleRadius))
        
        // 변경된 값 저장하기
        if index < locations.count && (locations[index].distance != targetDistance) {
            targetLocations[index].distance = targetDistance
            
            saveLocations(locations: targetLocations)
        }
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
        
// MARK: - 위치변경
    
    static func changeLocationOrder(locations: [Location], location: Location) {
        var targetLocations = locations
        
        // index값 가져오기
        guard let index = getIndexWithId(value: targetLocations, id: location.id ?? "") 
            else { return }
        
        // 해당 index의 값 지우기
        targetLocations.remove(at: index)
        
        // location을 locations의 맨 앞에 넣기
        targetLocations.insert(location, at: 0)
        
        // targetlocations를 Firestore에 save
        saveLocations(locations: targetLocations)
    }
    
    
// MARK: - 기타
    
    // Location 생성
    static func makeLocationByCurLocation() -> Location {
        return 
            Location(
                id: UUID().uuidString,
                lat: locationManager.lat,
                long: locationManager.long,
                city: locationManager.city,
                distriction: locationManager.distriction,
                dong: locationManager.dong,
                distance: 1,
                geohash: locationManager.geohash
            )
    }
    
    // User documnet 가져오기
    static func getUserDoc(id: String) -> DocumentReference  {
        return db.collection("User").document(id)
    }
    
    // Location index 탐색
    static func getIndexWithId(value: [Location]?, id: String) -> Int? {
        guard let index = value?.firstIndex(where: {$0.id == id}) else {
            print("선택한 Location을 찾을 수 없습니다.")
            return nil
        }
        
        return index
    }
    
}
