//
//  ClearBackground.swift
//  BookBridge
//
//  Created by 이민호 on 3/8/24.
//

import SwiftUI

struct ClearBackground: View {
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused.wrappedValue = false
            }
    }
}

