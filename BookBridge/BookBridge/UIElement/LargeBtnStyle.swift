//
//  LargeBtnStyle.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import SwiftUI

struct LargeBtnStyle: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.system(size: 20))
            .foregroundStyle(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "59AAE0"))
            .cornerRadius(10.0)
    }
}
