//
//  RegisterView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 10/07/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 20)
                
            
            Text("First Name")
            TextField("", text: $viewModel.firstName)
            
            Text("Last Name")
            TextField("", text: $viewModel.lastName)
            
            Text("Email")
            TextField("", text: $viewModel.email)
            
            Text("Password")
            SecureField("", text: $viewModel.password)
            
            Text("Confirm Password")
            SecureField("", text: $viewModel.passwordConfirmation)
            
            Button(action: {
//               Task avec la methode register à implementer
            }) {
                Text("Create")
            }
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(20)
        }
        .padding(50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}


#Preview {
    RegisterView()
}
