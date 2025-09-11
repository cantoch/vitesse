//
//  AuthenticationView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var viewModel = AuthenticationViewModel()
    @State private var showRegistration = false
    @StateObject private var candidateListVM = CandidateListViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Connexion")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityLabel("Ecran de connexion")
                .accessibilityHint("Saisissez votre email et votre mot de passe pour vous connecter")
                .padding(.bottom, 40)
            VStack(alignment: .leading, spacing: 20) {
                Text("Email/Nom d'utilisateur")
                TextField("Entrez votre email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .accessibilityLabel("Email ou nom d'utilisateur")
                    .accessibilityHint("Saisissez votre email ou nom d'utilisateur")
                Text("Mot de passe")
                SecureField("Entrez votre mot de passe", text: $viewModel.password)
                    .accessibilityLabel(Text("Mot de passe"))
                    .accessibilityHint(Text("Saisissez votre mot de passe"))
                if let error = viewModel.errorMessage {
                    Text(error.errorDescription ?? "")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                Text("Mot de passe oublié?")
                    .font(.caption)
            }
            .padding(EdgeInsets(top: 10, leading: 60, bottom: 30, trailing: 60))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            VStack {
                Button("Se connecter")
                {
                    Task {
                        await viewModel.login()
                    }
                }
                .accessibilityLabel("Se connecter")
                .accessibilityHint("Connexion à votre compte avec l'email et le mot de passe saisis")
                .font(.title3)
                .foregroundStyle(.white)
                .frame(maxWidth: 140,maxHeight: 50)
                .border(Color.black, width: 3)
                .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
                    NavigationStack {
                        CandidateListView(isLoggedIn: $viewModel.isLoggedIn, viewModel: candidateListVM)
                    }
                }
                .interactiveDismissDisabled(true)
                .background(Color.black)
                .cornerRadius(40)
                Spacer()
                Button("S'inscrire") {
                    showRegistration = true
                }
                .navigationDestination(isPresented: $showRegistration) {
                    RegistrationView {
                        showRegistration = false
                    }
                }
                .accessibilityLabel("S'inscrire")
                .accessibilityHint("Ouvre l'écran d'inscription")
                .font(.title3)
                .foregroundStyle(.white)
                .frame(maxWidth: 140,maxHeight: 50)
                .border(Color.black, width: 3)
                .background(Color.black)
                .cornerRadius(40)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    AuthenticationView()
}
