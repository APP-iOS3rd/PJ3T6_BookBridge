//
//  InputTextFieldStyle.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import SwiftUI

struct InputTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(Color(hex: "3C3C43"))
            .frame(height: 36)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "F7F8FC"))
            .cornerRadius(5.0)
    }
}
