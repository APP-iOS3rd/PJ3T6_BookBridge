//
//  StatusTextView.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import SwiftUI

struct StatusTextView: View {
    var text: String
    var color: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: color))
            Spacer()
        }
    }
}

//#Preview {
//    StatusTextView()
//}
