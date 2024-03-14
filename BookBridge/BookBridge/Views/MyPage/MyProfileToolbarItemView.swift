//
//  MyProfileToolbarItemsView.swift
//  BookBridge
//
//  Created by 노주영 on 2/23/24.
//

import SwiftUI

struct MyProfileToolbarItemView: View {
    @Binding var isDuplication: Bool
    @Binding var isEditing: Bool
    @Binding var nickname: String
    @Binding var userSaveImage: (String, UIImage)
    
    @StateObject var viewModel: MyProfileViewModel
    
    var body: some View {
        if isEditing {
            if  (viewModel.selectImage != userSaveImage.1 || viewModel.userNickname != nickname) && viewModel.userNickname != "" {
                MyProfileEditSaveButtonView(isDuplication: $isDuplication, isEditing: $isEditing, nickname: $nickname, userSaveImage: $userSaveImage, viewModel: viewModel)
            }
        } else {
            Button {
                isEditing.toggle()
            } label: {
                Text("편집")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black)
            }
        }
    }
}

