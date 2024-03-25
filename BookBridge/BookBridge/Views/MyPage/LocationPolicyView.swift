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
        PolicyWebView(url: URL(string: "https://internal-nest-08f.notion.site/4817aab9cde548e39b456fa3e7daf2a0?pvs=4")!)
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
