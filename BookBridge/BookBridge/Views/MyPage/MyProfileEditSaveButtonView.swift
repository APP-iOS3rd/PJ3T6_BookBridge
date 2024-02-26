//
//  MyProfileEditSaveView.swift
//  BookBridge
//
//  Created by 노주영 on 2/25/24.
//

import SwiftUI

struct MyProfileEditSaveButtonView: View {
    @Binding var isDuplication: Bool
    @Binding var isFalsePassword: Bool
    @Binding var isEditing: Bool
    @Binding var nickname: String
    @Binding var password: String
    @Binding var userSaveImage: (String, UIImage)
    
    @StateObject var viewModel: MyProfileViewModel
    
    var body: some View {
        Button {
            viewModel.doEditing(nickname: nickname, userSaveImage: userSaveImage, password: password) { (isDuplication, isFalsePassword, urlString) in
                if isDuplication {
                    if isFalsePassword {
                        self.isDuplication = true
                        self.isFalsePassword = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.isDuplication = false
                            self.isFalsePassword = false
                        }
                    } else {
                        self.isDuplication = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.isDuplication = false
                        }
                    }
                } else {
                    if isFalsePassword {
                        self.isFalsePassword = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.isFalsePassword = false
                        }
                    } else {
                        if viewModel.selectImage != userSaveImage.1 && viewModel.userNickname != nickname && viewModel.userPassword != password {
                            userSaveImage = (urlString, viewModel.selectImage ?? UIImage(named: "Character")!)
                            nickname = viewModel.userNickname
                            password = viewModel.userPassword
                            
                            viewModel.userManager.user?.profileURL = urlString
                            viewModel.userManager.user?.nickname = viewModel.userNickname
                            viewModel.userManager.user?.password = viewModel.userPassword
                        } else if viewModel.selectImage != userSaveImage.1 && viewModel.userNickname != nickname {
                            userSaveImage = (urlString, viewModel.selectImage ?? UIImage(named: "Character")!)
                            nickname = viewModel.userNickname
                            
                            viewModel.userManager.user?.profileURL = urlString
                            viewModel.userManager.user?.nickname = viewModel.userNickname
                        } else if viewModel.selectImage != userSaveImage.1 && viewModel.userPassword != password {
                            userSaveImage = (urlString, viewModel.selectImage ?? UIImage(named: "Character")!)
                            password = viewModel.userPassword
                            
                            viewModel.userManager.user?.profileURL = urlString
                            viewModel.userManager.user?.password = viewModel.userPassword
                        } else if viewModel.userNickname != nickname && viewModel.userPassword != password {
                            nickname = viewModel.userNickname
                            password = viewModel.userPassword
                            
                            viewModel.userManager.user?.nickname = viewModel.userNickname
                            viewModel.userManager.user?.password = viewModel.userPassword
                        } else if viewModel.selectImage != userSaveImage.1 {
                            userSaveImage = (urlString, viewModel.selectImage ?? UIImage(named: "Character")!)
                            
                            viewModel.userManager.user?.profileURL = urlString
                        } else if viewModel.userNickname != nickname {
                            nickname = viewModel.userNickname
                            
                            viewModel.userManager.user?.nickname = viewModel.userNickname
                        } else {
                            password = viewModel.userPassword
                            
                            viewModel.userManager.user?.password = viewModel.userPassword
                        }
                        isEditing.toggle()
                    }
                }
            }
        } label: {
            Text("완료")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.black)
        }
    }
}
