//
//  LargeBtnStyle.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import SwiftUI

struct LargeBtnStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .semibold))            
            .foregroundStyle(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "59AAE0"))
            .cornerRadius(10.0)
    }
}
