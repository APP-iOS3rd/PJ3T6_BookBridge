//
//  PrivacypolicyView.swift
//  BookBridge
//
//  Created by 김건호 on 3/11/24.
//

import SwiftUI
import WebKit


struct PrivacypolicyView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        PolicyWebView(url: URL(string: "https://internal-nest-08f.notion.site/766b05d6793240978526484520e205e3?pvs=4")!)
            .navigationBarBackButtonHidden()
            .navigationTitle("개인정보 처리방침")
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
