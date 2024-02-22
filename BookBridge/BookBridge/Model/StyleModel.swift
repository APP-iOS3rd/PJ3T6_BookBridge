//
//  StyleModel.swift
//  ModalPractice
//
//  Created by 노주영 on 2/7/24.
//

import Foundation

struct StyleModel: Identifiable {
    let id = UUID().uuidString
    var title: String
    var description: String
    var imageName: String
}
