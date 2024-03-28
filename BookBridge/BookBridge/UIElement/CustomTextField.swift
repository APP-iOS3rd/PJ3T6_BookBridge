//
//  CustomTextField.swift
//  BookBridge
//
//  Created by 이민호 on 3/7/24.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        // 자동 수정 비활성화
        textField.autocorrectionType = .no
        // 스펠링 검사 비활성화
        textField.spellCheckingType = .no
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ parent: CustomTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

