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
    @Binding var showPhoneView: Bool
    
    var body: some View {        
        ChangePhoneNumberStandardView(
            viewModel: viewModel,
            showNextPage: $showNextPage,
            showPhoneView: $showPhoneView
        )
        .navigationDestination(isPresented: $showNextPage) {
            ChangePhoneNumberView(showPhoneView: $showPhoneView)
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
