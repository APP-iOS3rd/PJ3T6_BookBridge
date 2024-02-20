//
//  AddBookBtnView.swift
//  BookBridge
//
//  Created by 김건호 on 2/2/24.
//

import SwiftUI

struct AddBookBtnView: View {
    
    @Binding var showingSheet: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        showingSheet = true                            
                    },
                    label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(Color(hex:"F6A65D"))
                            .frame(width: 50,height: 50)
                    }
                )
            }
        }
    }
}


