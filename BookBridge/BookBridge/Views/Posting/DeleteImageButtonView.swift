//
//  DeleteImageButtonView.swift
//  BookBridge
//
//  Created by 노주영 on 2/1/24.
//

import SwiftUI

struct DeleteImageButtonView: View {
    @Binding var items: [String]
    @Binding var selectedImages: [UIImage]
    
    var index: Int
    
    var body: some View {
        ZStack {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .frame(width: 25, height: 25)
        }
        .frame(width: 35, height: 35) // Delete버튼 범위
        .onTapGesture {
            if index < selectedImages.count {
                selectedImages.remove(at: index)
            }
        }
    }
}
