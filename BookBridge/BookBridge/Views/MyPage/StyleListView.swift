//
//  StyleListView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct StyleListView: View {
    @Binding var isModal: Bool
    @Binding var myStyles: [StyleModel]
    @Binding var selectedStyle: String
    @Binding var style: StyleModel
    
    var styleTypes: [StyleModel]
    
    var body: some View {
        VStack {
            ForEach(styleTypes) { style in
                HStack(alignment: .center) {
                    Text(style.title)
                        .padding(.vertical, 10)
                        .font(.system(size: 17, weight: (myStyles.contains { $0.title == style.title }) ? .semibold : .regular))
                        .foregroundStyle(
                            style.title == selectedStyle ? Color(hex: "59AAE0") : (myStyles.contains { $0.title == style.title }) ? .black : Color(hex: "767676")
                        )
                    Spacer()
                    
                    if style.title == selectedStyle {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 17))
                            .foregroundStyle(Color(hex: "59AAE0"))
                    }
                }
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.white)
                        .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
                )
                .onTapGesture {
                    self.style = style
                    isModal = true
                }
            }
        }
    }
}
