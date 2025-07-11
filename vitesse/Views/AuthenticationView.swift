//
//  AuthenticationView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject var viewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 20)
                
            
            Text("Email")
            TextField("Entrez votre email", text: $viewModel.email)
            
            Text("Password")
            SecureField("Entrez votre mot de passe", text: $viewModel.password)
            
            Button(action: {
                //action à inserer
            }) {
                Text("Sign in")
            }
            .font(.title3)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(20)
            .padding(.top, 30)
            
            Button(action: {
                //action à inserer
            }) {
                Text("Register")
            }
            .font(.title3)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(20)
        }
        .padding(50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
#Preview {
    AuthenticationView()
}
