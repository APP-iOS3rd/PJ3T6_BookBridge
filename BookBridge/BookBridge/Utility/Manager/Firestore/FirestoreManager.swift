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
                    
// MARK: - 삭제(delete)
    
    static func deleteLocation(id: String, locations: [Location]) {
        let docRef = FirestoreManager.getUserDoc(id: id)
        
        let locationData = locations.map { $0.dictionaryRepresentation }
        
        docRef.updateData([
            "location": locationData
        ]) { err in
            if let err = err {
                print(err)
                print("Location 삭제가 실패하였습니다.")
            } else {
                print("Location 삭제가 성공하였습니다.")
            }
        }
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
            let locationData = targetLocations.map { $0.dictionaryRepresentation }
            
            let docRef = db.collection("User").document(UserManager.shared.uid)
            
            docRef.updateData([
                "location": locationData
            ]) { err in
                if let err = err {
                    print(err)
                    print("Location 업데이트에 실패하였습니다.")
                } else {
                    print("Location 업데이트가 성공하였습니다.")
                }
            }
        }
    }
    
    // MARK: - 기타
    
    // Location 생성
    static func makeLocationByCurLocation() -> Location {
        return Location(id: UUID().uuidString, lat: locationManager.lat, long: locationManager.long, city: locationManager.city, distriction: locationManager.distriction, dong: locationManager.dong, distance: 1)
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
