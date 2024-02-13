//
//  NaverReverseGeocoding.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/06.
//

import Foundation

// NaverMap ReverseGeocoding API 호출관련 Model
struct NaverReverseGeocoding: Codable {
    let status: Status
    let results: [Result]?
}


// 상태 정보
struct Status: Codable {
    let code: Int
    let name: String
    let message: String
}

// 결과 리스트
struct Result: Codable {
    let name: String
    let code: Code
    let region: Region
    let land: Land
}

// 코드 정보
struct Code: Codable {
    let id: String
    let type: String
    let mappingId: String
}

// 지역 정보
struct Region: Codable {
    let area0, area1, area2, area3, area4: Area
}

// 구체적인 지역 단위
struct Area: Codable {
    let name: String
    let coords: Coords
    let alias: String?
    
    struct Coords: Codable {
        let center: Center
    }
    
    struct Center: Codable {
        let crs: String
        let x, y: Double
    }
}

// 토지 정보
struct Land: Codable {
    let type, number1, number2, name: String
    let addition0, addition1, addition2, addition3, addition4: Addition
    let coords: LandCoords
    
    struct Addition: Codable {
        let type: String
        let value: String
    }
    
    struct LandCoords: Codable {
        let center: Center
    }
    
    struct Center: Codable {
        let crs: String
        let x, y: Double
    }
}
