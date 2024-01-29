//
//  NaverLoginViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 1/29/24.
//

import Foundation
import NaverThirdPartyLogin

class NaverLoginViewModel : ObservableObject {
    @Published var isLogin: Bool = false
}
