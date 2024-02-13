//
//  BundleExtension.swift
//  BookBridge
//
//  Created by 이민호 on 2/5/24.
//

import Foundation

extension Bundle {
    var naverKeyId: String? {
        return infoDictionary?["naverKeyId"] as? String
    }
    
    var naverKey: String? {
        return infoDictionary?["naverKey"] as? String
    }
    
    var KakaoappKey : String? {
        return infoDictionary?["KakaoappKey"] as? String
    }
}
