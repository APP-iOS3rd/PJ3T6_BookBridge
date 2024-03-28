//
//  HideKeyboardExtension.swift
//  BookBridge
//
//  Created by 이현호 on 2/23/24.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
