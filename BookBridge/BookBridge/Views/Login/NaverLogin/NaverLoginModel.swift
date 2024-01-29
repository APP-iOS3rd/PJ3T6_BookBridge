//
//  NaverLoginModel.swift
//  BookBridge
//
//  Created by 노주영 on 1/29/24.
//

import Foundation

struct NaverLoginModel: Codable {
    /// 동일인 식별 정보 - 동일인 식별 정보는 네이버 아이디마다 고유하게 발급되는 값입니다.
    var id: String
    /// 사용자 별명
    var nickname: String?
    /// 사용자 이름
    var name: String?
    /// 사용자 메일 주소
    var email: String
    /// F: 여성 M: 남성 U: 확인불가
    var gender: String?
    /// 사용자 연령대
    var age: String?
    /// 사용자 생일(MM-DD 형식)
    var birthday: String?
    /// 사용자 프로필 사진 URL
    var profileimage: String?
}
