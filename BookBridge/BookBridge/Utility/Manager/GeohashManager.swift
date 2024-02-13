//
//  GeohashManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/13/24.
//

import FirebaseCore
import FirebaseFirestore
import GeoFire
import CoreLocation

class GeohashManager {
    static let db = Firestore.firestore()
    
    static func storeGeoHash(lat: Double, long: Double) -> String {
        // [START fs_geo_add_hash]
        // Compute the GeoHash for a lat/lng point
       
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let geoHash = GFUtils.geoHash(forLocation: location)
                
        return geoHash
    }
    
    static func geoQuery(lat: Double, long: Double, distance: Int, completion: @escaping ([Temp]) -> ()) async {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let radiusInM: Double = Double(distance) * 1000

        let queryBounds = GFUtils.queryBounds(forLocation: center, withRadius: radiusInM)
        let queries = queryBounds.map { bound -> Query in
            return db.collection("Location")
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }

        @Sendable func fetchMatchingDocs(from query: Query,
                                         center: CLLocationCoordinate2D,
                                         radiusInMeters: Double) async throws -> [Temp] {
            let snapshot = try await query.getDocuments()
            let tempArray = snapshot.documents.compactMap { document -> Temp? in
                    guard let data = document.data() as? [String: Any] else {
                        print("Error: Unable to retrieve document data")
                        return nil
                    }
                    
                    let name = data["name"] as? String ?? ""
                    let lat = data["lat"] as? Double ?? 0.0
                    let long = data["long"] as? Double ?? 0.0
                    let geohash = data["geohash"] as? String ?? ""
                    
                    let temp = Temp(name: name, lat: lat, long: long, geohash: geohash)
                    return temp
                }
            return tempArray.filter { temp -> Bool in
                let coordinates = CLLocation(latitude: temp.lat, longitude: temp.long)
                let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
                let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                return distance <= radiusInMeters
            }
        }

        do {
            let matchingTempArray = try await withThrowingTaskGroup(of: [Temp].self) { group -> [Temp] in
                for query in queries {
                    group.addTask {
                        try await fetchMatchingDocs(from: query, center: center, radiusInMeters: radiusInM)
                    }
                }
                var matchingTempArray = [Temp]()
                for try await tempArray in group {
                    matchingTempArray.append(contentsOf: tempArray)
                }
                return matchingTempArray
            }
            completion(matchingTempArray)
        } catch {
            print("Unable to fetch snapshot data. \(error)")
            completion([])
        }
    }
}
