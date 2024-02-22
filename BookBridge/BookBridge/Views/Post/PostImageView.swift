//
//  PostImageView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI

struct PostImageView: View {
    @Binding var url: [URL]
    
    var body: some View {
        TabView {
            ForEach(url, id: \.self) { element in
                AsyncImage(url: element) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                        .foregroundStyle(.black)
                } placeholder: {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                        .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
                }
                
            }
            if url.isEmpty {
                Image("Character")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                    .foregroundStyle(.black)
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
    }
}
