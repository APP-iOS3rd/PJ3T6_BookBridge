//
//  StyleViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 2/8/24.
//

import Foundation
import FirebaseFirestore

class StyleViewModel: ObservableObject {
    @Published var myStyles: [String] = []
    @Published var selectedStyle: String = ""
    @Published var style: StyleModel = StyleModel(title: "", description: "", imageName: "")
    
    let db = Firestore.firestore()
    let userManager = UserManager.shared
    
    //개발자가 넣고 싶은 칭호 전체
    let styleTypes: [StyleModel] = [
        StyleModel(title: "동네 보안관", description: "거래를 3번 이상하면 획득할 수 있어요.", imageName: "TownKeeper"),
        StyleModel(title: "백과사전", description: "보유중인 책이 10권 이상이면 획득할 수 있어요.", imageName: "TownKeeper"),
        StyleModel(title: "기부천사", description: "책을 기부하면 획득할 수 있어요. ", imageName: "TownKeeper"),
        StyleModel(title: "뉴비", description: "로그인에 성공하면 획득할 수 있어요.", imageName: "TownKeeper")
    ]
}

extension StyleViewModel {
    func changeSelectedStyle() {
        if selectedStyle == style.title {                   //선택취소
            db.collection("User").document(userManager.uid).updateData([
                "style": ""
            ])
            selectedStyle = ""
            userManager.user?.style = ""
        } else {                                            //선택완료
            db.collection("User").document(userManager.uid).updateData([
                "style": style.title
            ])
            selectedStyle = style.title
            userManager.user?.style = style.title
        }
    }
}
