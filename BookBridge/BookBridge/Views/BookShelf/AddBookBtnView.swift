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
                            .frame(width: 50,height: 50)
                            .foregroundColor(Color(hex:"59AAE0"))
                            .background(
                                Circle()
                                    .frame(width: 50,height: 50)
                                    .foregroundColor(.white)
                            )
                    }
                )
            }
        }
    }
}


