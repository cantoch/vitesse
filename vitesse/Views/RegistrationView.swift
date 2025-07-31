//
//  RegistrationView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 10/07/2025.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    let onRegisterComplete: () -> Void
    
    var body: some View {
        NavigationStack {
            Text("Register")
                .font(.system(size: 50))
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 40)
            VStack(alignment: .leading, spacing: 20) {
                Text("First Name")
                TextField("Entrez votre prénom", text: $viewModel.firstName)
                Text("Last Name")
                TextField("Entrez votre nom", text: $viewModel.lastName)
                Text("Entrez votre mail")
                TextField("Entrez votre mot de passe", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                Text("Password")
                SecureField("Entrez votre mot de passe", text: $viewModel.password)
                Text("Confirm Password")
                SecureField("Confirmez votre mot de passe", text: $viewModel.passwordConfirmation)
            }
            .padding(EdgeInsets(top: 10, leading: 60, bottom: 30, trailing: 60))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            VStack {
                Button(action: {
                    Task {
                        try? await viewModel.register()
                        onRegisterComplete()
                    }
                }) {
                    Text("Create")
                }
                .font(.title3)
                .foregroundStyle(.white)
                .frame(maxWidth: 120,maxHeight: 40)
                .border(Color.black, width: 3)
                .background(Color.black)
                .cornerRadius(40)
                .padding(.bottom, 10)
            }
        }
    }
}


#Preview {
    RegistrationView { }
}
