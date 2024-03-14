//
//  ChatImageModalView.swift
//  BookBridge
//
//  Created by 이현호 on 3/11/24.
//

import SwiftUI
import Kingfisher

struct ChatImageModalView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ChatMessageViewModel
    
//    @Binding var isSelectedIamge: Bool
//    
    var messageModel: ChatMessageModel

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
                
                Image(uiImage: viewModel.chatImages[messageModel.imageURL] ?? UIImage(named: "DefaultImage")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.75)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.45)

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
