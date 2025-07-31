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
    
    var body: some View {
        NavigationStack {
            Text("Login")
                .font(.system(size: 50))
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 40)
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Email/Username")
                TextField("Entrez votre email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                Text("Password")
                SecureField("Entrez votre mot de passe", text: $viewModel.password)
                Text("Forgot password?")
                    .font(.caption)
            }
            .padding(EdgeInsets(top: 10, leading: 60, bottom: 30, trailing: 60))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            VStack {
                Button("Sign in")
                {
                    Task {
                        try? await viewModel.login()
                    }
                }
                
                .font(.title3)
                .foregroundStyle(.white)
                .frame(maxWidth: 120,maxHeight: 40)
                .border(Color.black, width: 3)
                .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                    CandidateListView()
                }
                .background(Color.black)
                .cornerRadius(40)
                Spacer()
                Button("Register") {
                    showRegistration = true
                }
                .navigationDestination(isPresented: $showRegistration) {
                    RegistrationView {
                        showRegistration = false
                    }
                }
                .font(.title3)
                .foregroundStyle(.white)
                .frame(maxWidth: 120,maxHeight: 40)
                .border(Color.black, width: 3)
                .background(Color.black)
                .cornerRadius(40)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
        }
    }
}

#Preview {
    AuthenticationView()
}
