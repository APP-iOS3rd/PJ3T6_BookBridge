//
//  MyProfileEditSaveView.swift
//  BookBridge
//
//  Created by 노주영 on 2/25/24.
//

import SwiftUI

struct MyProfileEditSaveButtonView: View {
    @Binding var isDuplication: Bool
    @Binding var isEditing: Bool
    @Binding var nickname: String
    @Binding var userSaveImage: (String, UIImage)
    
    @StateObject var viewModel: MyProfileViewModel
    
    var body: some View {
        Button {
            viewModel.doEditing(nickname: nickname, userSaveImage: userSaveImage) { (isDuplication, urlString) in
                if isDuplication {
                    self.isDuplication = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.isDuplication = false
                    }
                } else {
                    if viewModel.selectImage != userSaveImage.1 && viewModel.userNickname != nickname {
                        userSaveImage = (urlString, viewModel.selectImage ?? UIImage(named: "Character")!)
                        nickname = viewModel.userNickname
                        
                        viewModel.userManager.user?.profileURL = urlString
                        viewModel.userManager.user?.nickname = viewModel.userNickname
                    } else if viewModel.selectImage != userSaveImage.1 {
                        userSaveImage = (urlString, viewModel.selectImage ?? UIImage(named: "Character")!)
                        
                        viewModel.userManager.user?.profileURL = urlString
                    } else {
                        nickname = viewModel.userNickname
                        
                        viewModel.userManager.user?.nickname = viewModel.userNickname
                    }
                    isEditing.toggle()
                }
            }
        } label: {
            Text("완료")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.black)
        }
    }
}
