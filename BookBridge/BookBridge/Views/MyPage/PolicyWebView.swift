//
//  PrivacypolicyWebView.swift
//  BookBridge
//
//  Created by 김건호 on 3/11/24.
//

import Foundation
import SwiftUI
import WebKit

struct PolicyWebView: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
