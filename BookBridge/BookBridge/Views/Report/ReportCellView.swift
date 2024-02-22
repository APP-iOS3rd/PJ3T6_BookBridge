//
//  ReportCellView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/14.
//

import SwiftUI

struct ReportCellView: View {
    
    let contents: String

    var body: some View {
            HStack {
                Text(contents)
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 17))
                    .foregroundStyle(Color(hex: "3C3C43"))
            }
            .padding(.horizontal, 21)
            .padding(.top, 10)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "E8E8E8"), radius: 0, x: 0, y: 1)
                    .padding(.leading, 21)
                    .padding(.trailing, 21)
            )
        
    }
}
