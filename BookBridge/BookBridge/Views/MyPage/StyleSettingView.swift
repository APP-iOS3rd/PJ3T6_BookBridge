//
//  StyleSettingView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI

struct StyleSettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isModal: Bool = false
    @State private var myStyles: [StyleModel] = [
        StyleModel(title: "동네보안관", description: "거래를 3번 이상하면 획득할 수 있어요.", imageName: "TownKeeper"),
        StyleModel(title: "뉴비", description: "로그인에 성공하면 획득할 수 있어요.", imageName: "TownKeeper")
    ]
    @State private var selectedStyle: String = ""
    @State private var style: StyleModel = StyleModel(title: "", description: "", imageName: "")
    
    let styleTypes: [StyleModel] = [
        StyleModel(title: "동네보안관", description: "거래를 3번 이상하면 획득할 수 있어요.", imageName: "TownKeeper"),
        StyleModel(title: "백과사전", description: "보유중인 책이 10권 이상이면 획득할 수 있어요.", imageName: "TownKeeper"),
        StyleModel(title: "기부천사", description: "책을 기부하면 획득할 수 있어요. ", imageName: "TownKeeper"),
        StyleModel(title: "뉴비", description: "로그인에 성공하면 획득할 수 있어요.", imageName: "TownKeeper")
    ]
    
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
            
            StyleListView(isModal: $isModal, myStyles: $myStyles, selectedStyle: $selectedStyle, style: $style, styleTypes: styleTypes)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("칭호")
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
            StyleModalView(isModal: $isModal, myStyles: $myStyles, selectStyle: $selectedStyle, style: $style)
                .presentationDetents([.height(250)])
        })
    }
}

#Preview {
    StyleSettingView()
}

