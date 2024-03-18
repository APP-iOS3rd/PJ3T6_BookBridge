//
//  PostImageModalView.swift
//  BookBridge
//
//  Created by 이현호 on 2/23/24.
//

import SwiftUI
import Kingfisher

struct PostImageModalView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var urlString: [String]
    @Binding var selectedImageUrl: String?
    
    @State private var currentIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                }
                .padding()
                
                TabView(selection: $currentIndex) {
                    ForEach(urlString.indices, id: \.self) { index in
                        KFImage(URL(string: urlString[index]))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    }
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .onAppear {
                    if let selectedImageUrl = selectedImageUrl,
                       let index = urlString.firstIndex(of: selectedImageUrl) {
                        currentIndex = index
                    }
                }
            }
            .gesture(
                DragGesture().onEnded { value in
                    if value.location.y - value.startLocation.y > 150 {
                        dismiss()
                    }
                }
            )
            .background(.black)
        }
    }
}
