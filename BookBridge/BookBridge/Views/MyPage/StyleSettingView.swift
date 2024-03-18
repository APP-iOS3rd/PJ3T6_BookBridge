//
//  StyleSettingView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI

struct StyleSettingView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject var viewModel = StyleViewModel()
    
    @State private var isModal: Bool = false
    
    var userId: String
    var userStyle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("획득한 칭호를 선택해주세요")
                .font(.system(size: 24, weight: .bold))
                .padding(.vertical, 10)
                .padding(.top, 10)
            
            Text("프로필 정보에 표시돼요")
                .font(.system(size: 15))
                .foregroundStyle(Color(hex: "767676"))
            Text("나를 표현할 칭호를 선택해주세요.")
                .font(.system(size: 15))
                .foregroundStyle(Color(hex: "767676"))
                .padding(.bottom, 20)
            
            StyleListView(isModal: $isModal, viewModel: viewModel)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("칭호")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }
        .sheet(isPresented: $isModal, onDismiss: {
            isModal = false
        }, content: {
            StyleModalView(isModal: $isModal, viewModel: viewModel, userId: userId)
                .presentationDetents([.height(250)])
        })
        .onAppear {
            viewModel.myStyles = UserManager.shared.user?.titles ?? ["뉴비"]
            viewModel.selectedStyle = userStyle
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

