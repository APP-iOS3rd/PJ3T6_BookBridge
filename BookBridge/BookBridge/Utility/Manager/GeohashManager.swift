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

enum BoardType {
    case change
    case find
}

enum GeoQueryError: Error {
    case invalidData
    case invalidTimestamp
    case invalidHopeBooks
}

class GeohashManager {
    static let db = Firestore.firestore()
    
    static func getGeoHash(lat: Double, long: Double) -> String {
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let geoHash = GFUtils.geoHash(forLocation: location)
                
        return geoHash
    }
    
    static func geoQuery(lat: Double, long: Double, distance: Int, type: BoardType) async -> [NoticeBoard] {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let radiusInM: Double = Double(distance) * 1000

        let queryBounds = GFUtils.queryBounds(forLocation: center, withRadius: radiusInM)
        let queries = queryBounds.map { bound -> Query in
            return db.collection("noticeBoard")
                .order(by: "geoHash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }

        @Sendable func fetchMatchingDocs(from query: Query, center: CLLocationCoordinate2D, radiusInMeters: Double) async throws -> [NoticeBoard] {
                                         
            let snapshot = try await query.getDocuments()
            var noticeBoards = [NoticeBoard]()
            _ = try await withThrowingTaskGroup(of: NoticeBoard.self) { group in
                for document in snapshot.documents {
                    group.addTask {
                        return try await getNoticeBoard(from: document)
                    }
                }
                for try await noticeBoard in group {
                    noticeBoards.append(noticeBoard)
                }
                return noticeBoards
            }
            
            return noticeBoards.filter { noticeBoard -> Bool in
                switch type {
                case .change:
                    if noticeBoard.isChange {
                        return isWithinRadius(location: noticeBoard.noticeLocation, center: center, radiusInMeters: radiusInMeters)
                    }
                case .find:
                    if !noticeBoard.isChange {
                        return isWithinRadius(location: noticeBoard.noticeLocation, center: center, radiusInMeters: radiusInMeters)
                    }
                }
                                
                return false
            }
            .sorted { $0.date > $1.date }
            .filter { $0.state == 0 }
        }
        
        @Sendable func getNoticeBoard(from document: DocumentSnapshot) async throws -> NoticeBoard {
            guard let data = document.data() else {
                throw GeoQueryError.invalidData // 데이터가 유효하지 않은 경우 에러를 던집니다.
            }
            
            guard let timestamp = document.data()?["date"] as? Timestamp else {
                throw GeoQueryError.invalidTimestamp // 타임스탬프가 유효하지 않은 경우 에러를 던집니다.
            }
            
            let id = data["noticeBoardId"] as? String ?? ""
            let userId = document.data()?["userId"] as? String ?? ""
            let noticeBoardTitle = document.data()?["noticeBoardTitle"] as? String ?? ""
            let noticeBoardDetail = document.data()?["noticeBoardDetail"] as? String ?? ""
            let noticeImageLink = document.data()?["noticeImageLink"] as? [String] ?? []
            let noticeLocation = document.data()?["noticeLocation"] as? [Double] ?? []
            let noticeLocationName = document.data()?["noticeLocationName"] as? String ?? ""
            let isChange = document.data()?["isChange"] as? Bool ?? false
            let state = document.data()?["state"] as? Int ?? 0
            let date = timestamp.dateValue()
            let hopeBook = try await FirestoreManager.fetchHopeBook(uid: id)
            let geoHash = document.data()?["geohash"] as? String ?? ""
            let reservationId = document.data()?["reservationId"] as? String ?? ""
            let isAddLocation = document.data()?["isAddLocation"] as? Bool ?? false
                        
            let noticeBoard = NoticeBoard(
                id: id,
                userId: userId,
                noticeBoardTitle: noticeBoardTitle,
                noticeBoardDetail: noticeBoardDetail,
                noticeImageLink: noticeImageLink,
                noticeLocation: noticeLocation,
                noticeLocationName: noticeLocationName,
                isChange: isChange,
                state: state,
                date: date,
                hopeBook: hopeBook ?? [],
                geoHash: geoHash,
                reservationId: reservationId,
                isAddLocation: isAddLocation
            )
            
            return noticeBoard
        }
        
        @Sendable func isWithinRadius(location: [Double], center: CLLocationCoordinate2D, radiusInMeters: CLLocationDistance) -> Bool {
            let coordinates = CLLocation(latitude: location[0], longitude: location[1])
            let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
            return distance <= radiusInMeters
        }
        
        
        do {
            let matchingTempArray = try await withThrowingTaskGroup(of: [NoticeBoard].self) { group -> [NoticeBoard] in
                for query in queries {
                    group.addTask {
                        try await fetchMatchingDocs(from: query, center: center, radiusInMeters: radiusInM)
                    }
                }
                var matchingTempArray = [NoticeBoard]()
                for try await tempArray in group {
                    matchingTempArray.append(contentsOf: tempArray)
                }
                return matchingTempArray
            }
            
            return matchingTempArray
        } catch {
            print("Unable to fetch snapshot data. \(error)")
            return []
        }
    }
}
