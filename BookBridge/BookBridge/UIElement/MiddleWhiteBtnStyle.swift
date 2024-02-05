//
//  MiddleWhiteBtnStyle.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import SwiftUI

struct MiddleWhiteBtnStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17))
            .foregroundStyle(Color(hex: "59AAE0"))
            .frame(width: 100, height: 36)
            .border(Color(hex: "59AAE0"), width: 2)
            .background(.white)
            .cornerRadius(5.0)
    }
}
