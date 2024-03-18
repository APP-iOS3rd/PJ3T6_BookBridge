//
//  ToastMessageView.swift
//  BookBridge
//
//  Created by jonghyun baik on 3/6/24.
//

import SwiftUI

struct ToastMessageView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("주소가 복사되었습니다")
                .padding()
                .foregroundColor(.white)
                .background(Color(.lightGray))
                .cornerRadius(10)
                .opacity(isShowing ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: isShowing)
        }
        .padding(.horizontal, 30)
        .transition(.move(edge: .bottom))
    }
}
