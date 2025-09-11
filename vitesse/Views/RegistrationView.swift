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
            Text("Inscription")
                .font(.system(size: 50))
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 40)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel("Inscription")
                .accessibilityHint("Formulaire d'inscription")
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Prénom")
                TextField("Entrez votre prénom", text: $viewModel.firstName)
                    .accessibilityLabel("Prénom")
                    .accessibilityHint("Saisissez votre prénom")
                Text("Nom")
                TextField("Entrez votre nom", text: $viewModel.lastName)
                    .accessibilityLabel("Nom")
                    .accessibilityHint("Saisissez votre nom de famille")
                Text("Entrez votre mail")
                    .accessibilityLabel("Adresss e-mail")
                    .accessibilityHint("Saisissez votre adresse e-mail")
                TextField("Entrez votre mot de passe", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                Text("Mot de passe")
                SecureField("Entrez votre mot de passe", text: $viewModel.password)
                    .accessibilityLabel("Entrez votre mot de passe")
                    .accessibilityHint("Saisissez un mot de passe sécurisé pour votre compte")
                Text("Mot de passe à confirmer")
                SecureField("Confirmez votre mot de passe", text: $viewModel.passwordConfirmation)
                    .accessibilityLabel("Confirmez votre mot de passe")
                    .accessibilityHint("Ressaisissez votre mot de passe pour le confirmer")
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
                    Text("Valider")
                }
                .accessibilityLabel("Valider l'inscription")
                .accessibilityHint("Crée le compte avec les informations saisies")
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
