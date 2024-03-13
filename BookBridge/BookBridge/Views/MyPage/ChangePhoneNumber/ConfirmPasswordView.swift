//
//  ConfirmPasswordView.swift
//  BookBridge
//
//  Created by 이민호 on 3/11/24.
//

import SwiftUI

struct ConfirmPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ChangePhonenumberViewModel()
    @State var showNextPage = false
    
    var body: some View {        
        ChangeStandardView(
            viewModel: viewModel,
            showNextPage: $showNextPage
        )
        .navigationDestination(isPresented: $showNextPage) {
            ChangePhoneNumberView()
        }
        .onAppear() {
            viewModel.setPasswordState()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
                
            }
        }
    }
}

//#Preview {
//    ConfirmPasswordView()
//}
