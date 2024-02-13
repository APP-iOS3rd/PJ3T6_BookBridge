//
//  AddButtonView.swift
//  BookBridge
//
//  Created by 김건호 on 2/1/24.
//

import SwiftUI

struct AddButtonView: View {
    var body: some View {
        VStack {
          Spacer()
          
          HStack {
            Spacer()
            
            Button(
              action: {
    //            pathModel.paths.append(.)
              },
              label: {
                Image("plus.circle.fill")
                  
                      
              }
            )
          }
        }
    }
}

#Preview {
    AddButtonView()
}
