//
//  LocationPolicyView.swift
//  BookBridge
//
//  Created by 이현호 on 3/18/24.
//

import SwiftUI
import WebKit

struct LocationPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        PolicyWebView(url: URL(string: "https://chambray-turnip-1a2.notion.site/4dc8072eb62747249f729e4081a1009a?pvs=4")!)
            .navigationBarBackButtonHidden()
            .navigationTitle("위치기반서비스 이용약관")
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
            
    }
}
