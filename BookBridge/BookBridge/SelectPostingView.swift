//
//  SelectPostingView.swift
//  BookBridge
//
//  Created by 노주영 on 2/20/24.
//

import SwiftUI

struct SelectPostingView: View {
    @Binding var height: CGFloat
    @Binding var isAnimating: Bool
    @Binding var isShowChange: Bool
    @Binding var isShowFind: Bool
    
    var sortTypes: [String]
    
    var body: some View {
        VStack {
            ForEach(sortTypes.indices) { sortIndex in
                Text(sortTypes[sortIndex])
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .frame(width: 140)
                    .onTapGesture {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                            isAnimating = false
                            if sortIndex == 0 {
                                isShowFind = true
                            } else {
                                isShowChange = true
                            }
                        }
                        
                        withAnimation {
                            height = 0.0
                        }
                    }
                    .padding(.vertical, -5)
                
                if sortIndex == 0 {
                    Divider()
                        .frame(width: 140)
                }
            }
        }
        .frame(height: height)
        .cornerRadius(5)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color(uiColor: .systemGray6))
                .shadow(color: Color.init(hex: "767676"), radius: 1, x: 0, y: 1)
            //.shadow(color: Color.init(hex: "767676"), radius: 1, x: 0, y: -1)
        )
    }
}
