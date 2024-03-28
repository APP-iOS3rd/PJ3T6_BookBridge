//
//  TestView.swift
//  BookBridge
//
//  Created by 이민호 on 2/4/24.
//

import SwiftUI

struct TestView: View {
    @StateObject var testVM = TestViewModel()
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            if testVM.value {
                Text("Transition Test")
                    .transition(.scale)
            }
        }
        
        
        Button {
            withAnimation {
                testVM.value.toggle()
            }
        } label: {
            Text("click here")
        }
        
    }
}

#Preview {
    TestView()
}
