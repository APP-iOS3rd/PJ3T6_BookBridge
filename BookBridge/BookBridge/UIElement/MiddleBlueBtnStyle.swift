//
//  MiddleBtnStyleWhite.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import SwiftUI

struct MiddleBlueBtnStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17))
            .foregroundStyle(.white)
            .frame(width: 100, height: 36)
            .background(Color(hex: "59AAE0"))
            .cornerRadius(5.0)
    }
}
