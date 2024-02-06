//
//  WishBookAddBtnView.swift
//  BookBridge
//
//  Created by 김건호 on 2/2/24.
//

import SwiftUI

struct WishBookAddBtnView: View {
    
    @EnvironmentObject var viewModel: BookShelfViewModel
    
    @Environment(\.dismiss) private var dismiss
    var book : Item
    var body: some View {
        Button(
            action: {
                if !(viewModel.wishBooks.contains{ $0.id == book.id }){
                    viewModel.wishBooks.append(book)
                }
                
                dismiss()
            },
            label: {
                Text("나의 희망도서로 등록")
                    .font(.system(size:12,weight: .bold))
                    .frame(width: 120,height: 31)
                    .foregroundColor(Color(hex:"FFFFFF"))
                    .background(Color(hex: "59AAE0"))
                    .cornerRadius(10)
                
            }
        )
        
    }
}



//#Preview {
//    WishBookAddBtnView()
//}
