//
//  TermsOfServiceView.swift
//  BookBridge
//
//  Created by 이현호 on 3/18/24.
//

import SwiftUI
import WebKit

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        PolicyWebView(url: URL(string: "https://internal-nest-08f.notion.site/39360863e97647e796cbe7a2788dcaea")!)
            .navigationBarBackButtonHidden()
            .navigationTitle("서비스 이용약관")
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
