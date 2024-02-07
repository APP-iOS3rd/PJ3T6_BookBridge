//
//  User.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/01/30.
//

import Foundation

//User라고 할 경우 AuthDataResultModel에 User와 충돌 이슈
struct UserModel: Codable, Identifiable {
    var id: String?                    //고유 아이디 CI 값
    var email: String?                //로그인 아이디
    var loginId: String?
    var passsword: String?                //비밀번호
    var nickname: String?                //닉네임
    var phoneNumber: String?            //보류
    var profileURL: String?                //프사    
    var joinDate: Date?                  //가입일 (파베는 number
    var fcmToken: String?                //fcm 토큰
    var location: [Location?]?                  // 대표 위치
}
