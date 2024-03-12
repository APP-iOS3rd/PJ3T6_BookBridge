//
//  AlarmView.swift
//  BookBridge
//
//  Created by 김건호 on 3/12/24.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject private var pathModel: TabPathViewModel
    @Environment(\.dismiss) var dismiss
    
    var cnt : Int = 10
    var body: some View {
        List {
            ForEach(0..<cnt) {_ in
                Button {
                    
                } label: {
                    VStack{
                        NotificationItemVIew()
                    }
                }
                
            }
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
}
