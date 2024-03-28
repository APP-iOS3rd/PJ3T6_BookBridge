//
//  SMTP_SET.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import Foundation
import SwiftSMTP

let smtp = SMTP(
    hostname: "smtp.gmail.com",
    email: "minho100227@gmail.com",
    password: "xhvo wqax gnab focq"
)

let mail_from = Mail.User(name: "Book Bridge", email: "minho100227@gmail.com")

func emailContent(code: String) -> String {
    return """
            북다리 이메일 인증번호입니다.
            아래의 인증번호를 App에서 입력해 주시기 바랍니다.
            \(code)
           """
}

let mail_to = Mail.User(name: "mail_to", email: "bluemango608@gmail.com")

let mail = Mail(
    from: mail_from,
    to: [mail_to],
    subject: "북다리 인증번호",
    text: "102486"
)

func createEmailCode() -> String {
    let codeChar = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var certiCode: String = ""
    
    for _ in 0...5 {
        let randNum = Int.random(in: 0..<codeChar.count)
        certiCode += codeChar[randNum]
    }
    return certiCode
}
