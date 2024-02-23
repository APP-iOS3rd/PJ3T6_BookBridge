//
//  NoticeBoardSortView.swift
//  BookBridge
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct NoticeBoardSortView: View {
    @Binding var height: CGFloat
    @Binding var index: Int
    @Binding var isAnimating: Bool
    
    var sortTypes: [String]
    
    var body: some View {
        VStack {
            ForEach(sortTypes.indices) { sortIndex in
                Text(sortTypes[sortIndex])
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .frame(maxWidth: 140)
                    .background(
                        index == sortIndex ? Color(hex: "D9D9D9") : .white
                    )
                    .onTapGesture {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                            isAnimating = false
                        }
                        
                        withAnimation {
                            index = sortIndex
                            height = 0.0
                        }
                    }
                    .padding(.vertical, -5)
            }
        }
        .frame(height: height)
        .cornerRadius(5)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.red)
                .shadow(color: Color.init(hex: "767676"), radius: 1, x: 0, y: 1)
                //.shadow(color: Color.init(hex: "767676"), radius: 1, x: 0, y: -1)
        )
    }
}

