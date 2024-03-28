//
//  NaverLocationService.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/06.
//

import Foundation
import NMapsMap

struct LocationInfo {
    let name: String
    let latitude: Double
    let longitude: Double
}

class NaverLocationService {
    static let shared = NaverLocationService()
    
    private init() {}
    
    func fetchLocationInfo(for position: NMGLatLng, completion: @escaping (LocationInfo?) -> Void) {
        // Naver 지도 Reverse Geocoding API URL 구성
        guard let naverKeyID = Bundle.main.object(forInfoDictionaryKey: "naverKeyId") as? String,
              let naverKey = Bundle.main.object(forInfoDictionaryKey: "naverKey") as? String,
              let url = URL(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=\(position.lng),\(position.lat)&orders=roadaddr&output=json") else {
            print("Invalid API Key or URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(naverKeyID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(naverKey, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(NaverReverseGeocoding.self, from: data)
                guard let result = decodedData.results?.first else {
                    completion(nil)
                    return
                }
                let seeDo = result.region.area1.name
                let seeGunGu = result.region.area2.name
                let dong = result.region.area3.name
                let gil = result.land.name
                let landNumber = result.land.number1
                let landValue = result.land.addition0.value
                
                let name = [seeDo, seeGunGu, dong, gil, landNumber, landValue].joined(separator: " ")
                let info = LocationInfo(name: name, latitude: position.lat, longitude: position.lng)
                completion(info)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
