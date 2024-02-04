//
//  LoadingCircle.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import SwiftUI

struct LoadingCircle: View {
    @State private var isLoading = false
    var size: CGFloat
    var color: String
    
    private var animation: Animation {
        .easeInOut(duration: 0.3)
        .speed(0.3)
        .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color(hex: color), lineWidth: 2)
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .onAppear() {
                withAnimation(animation) {
                    self.isLoading = true
                }
            }
    }
}

#Preview {
    LoadingCircle(size: 25, color: "59AAE0")
}
