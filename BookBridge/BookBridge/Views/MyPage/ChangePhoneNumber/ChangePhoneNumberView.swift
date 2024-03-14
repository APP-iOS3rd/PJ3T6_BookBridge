//
//  ChangePhoneNumberView.swift
//  BookBridge
//
//  Created by 이민호 on 3/11/24.
//

import SwiftUI

struct ChangePhoneNumberView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ChangePhonenumberViewModel()
    @State var showNextPage = false
    @State var verificationID = ""
    @State var newPhoneNumber = ""
    @Binding var showPhoneView: Bool
    
    var body: some View {
        ChangePhoneNumberStandardView(
            viewModel: viewModel,
            showNextPage: $showNextPage,
            showPhoneView: $showPhoneView
        )
        .navigationDestination(isPresented: $showNextPage) {            
            ConfirmPhoneNumberView(
                verificationID: $verificationID,
                newPhoneNumber: $newPhoneNumber,
                showPhoneView: $showPhoneView
            )
        }
        .onAppear() {
            viewModel.setPhoneNumberState()
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
        .onChange(of: viewModel.verificationID) { result in
            self.verificationID = result
        }
        .onChange(of: viewModel.newPhoneNumber) { result in
            self.newPhoneNumber = result
        }
    }
}

//#Preview {
//    ChangePhoneNumberView()
//}
