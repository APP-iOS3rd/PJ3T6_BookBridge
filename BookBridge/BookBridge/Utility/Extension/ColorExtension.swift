//
//  ColorExtension.swift
//  BookBridge
//
//  Created by 이민호 on 1/25/24.
//

import SwiftUI

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
    
    func asUIColor() -> UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        } else {
            // iOS 13 이하 버전에서는 이전에 설명한 방법을 사용할 수 있습니다.
            // 여기에 해당 코드를 채워넣으세요.
            // iOS 14 이상에서는 사용되지 않으므로 여기에는 아무 것도 넣지 않아도 됩니다.
            return UIColor.white // 예시로 UIColor.white를 반환합니다.
        }
    }
}

