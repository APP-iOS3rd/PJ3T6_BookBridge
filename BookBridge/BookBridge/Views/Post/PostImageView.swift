//
//  PostImageView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI
import Kingfisher

struct PostImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedImageUrl: String?
    @State private var isShowImageModal = false
    var urlString: [String]
    
    
    var body: some View {
        TabView {
            ForEach(urlString, id: \.self) { element in
                KFImage(URL(string: element))
                    .placeholder {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                            .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                    .foregroundStyle(.black)
                    .onTapGesture {
                        selectedImageUrl = element
                        isShowImageModal = true
                    }
            }
        }
        .tabViewStyle(.page)
        .frame(height: UIScreen.main.bounds.width * 0.5625)
        .background(
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
        )
        .padding(.bottom)
        .fullScreenCover(isPresented: $isShowImageModal) {
            PostImageModalView(urlString: urlString, selectedImageUrl: $selectedImageUrl)
        }
    }
}
