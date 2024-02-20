//
//  NaverMapApiManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import Foundation

class NaverMapApiManager {
    static let ADDRESS_URL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
    static var NAVER_API_ID: String?ㄱ
    static var NAVER_API_KEY: String?
    
    static func getNaverApiInfo() {
        do {
            NaverMapApiManager.NAVER_API_ID = try KeychainManager.load(account: "X-NCP-APIGW-API-KEY-ID")
            
            NaverMapApiManager.NAVER_API_KEY = try KeychainManager.load(account: "X-NCP-APIGW-API-KEY")
        } catch let err {
            print(err.localizedDescription)
        }
    }
}
