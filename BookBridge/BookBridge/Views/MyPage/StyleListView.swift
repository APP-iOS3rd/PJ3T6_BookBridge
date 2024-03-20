//
//  StyleListView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/7/24.
//

import SwiftUI

struct StyleListView: View {
    @Binding var isModal: Bool
    
    @StateObject var viewModel: StyleViewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.styleTypes) { style in
                HStack(alignment: .center) {
                    Text(style.title)
                        .padding(.vertical, 10)
                        .font(.system(size: 17, weight: (viewModel.myStyles.contains { $0 == style.title }) ? .semibold : .regular))
                        .foregroundStyle(
                            style.title == viewModel.selectedStyle ? Color(hex: "59AAE0") : (viewModel.myStyles.contains { $0 == style.title }) ? .black : Color(hex: "767676")
                        )
                    Spacer()
                    
                    if style.title == viewModel.selectedStyle {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 17))
                            .foregroundStyle(Color(hex: "59AAE0"))
                    }
                }
                .frame(height: 50)
                .onTapGesture {
                    viewModel.style = style
                    isModal = true
                }
                Divider()
            }
        }
    }
}
