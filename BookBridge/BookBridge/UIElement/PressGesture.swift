//
//  PressGesture.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/04/05.
//

import SwiftUI

struct PressGesture: ViewModifier {
    
    @Binding var shouldShowActionSheet: Bool
    @Binding var isPressed: Bool
    
    func body(content: Content) -> some View {
        content
        .onLongPressGesture(minimumDuration: 0.4) {
            shouldShowActionSheet = true
            // 진동 효과
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        } onPressingChanged: { inProgress in //눌렀을때 색 변경 트리거
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                withAnimation{
                    isPressed = false
                }
            }
        }
    }
}
