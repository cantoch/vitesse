//
//  CandidateCreationView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 05/08/2025.
//

import SwiftUI

struct CandidateCreationView: View {
    @ObservedObject var viewModel: CandidateCreationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("Email")
                            .fontWeight(.bold)
                            .frame(width: 100, height: 30, alignment: .leading)
                        TextField("", text: $viewModel.email)
                    }
                    VStack(alignment: .leading) {
                        Text("Note")
                            .fontWeight(.bold)
                            .frame(width: 100, height: 30, alignment: .leading)
                        TextField("", text: $viewModel.note)
                    }
                    VStack(alignment: .leading) {
                        Text("LinkedIn")
                            .fontWeight(.bold)
                            .frame(width: 100, height: 30, alignment: .leading)
                        TextField("", text: $viewModel.linkedinURL)
                    }
                    VStack(alignment: .leading) {
                        Text("firstName")
                            .fontWeight(.bold)
                            .frame(width: 100, height: 30, alignment: .leading)
                        TextField("", text: $viewModel.firstName)
                    }
                    VStack(alignment: .leading) {
                        Text("lastName")
                            .fontWeight(.bold)
                            .frame(width: 100, height: 30, alignment: .leading)
                        TextField("", text: $viewModel.lastName)
                    }
                    VStack(alignment: .leading) {
                        Text("Phone")
                            .fontWeight(.bold)
                            .frame(width: 100, height: 30, alignment: .leading)
                        TextField("", text: $viewModel.phone)
                    }
                    .padding(.bottom, 10)
                    
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .navigationTitle("New candidate")
                Button(action: {
                    Task {
                        try await self.viewModel.addCandidate()
                        dismiss()
                    }
                }) {
                    Text("Add candidate")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

#Preview {
    CandidateCreationView(viewModel: CandidateCreationViewModel(candidate: CandidateRequest(
        email: "jane.doe@example.com",
        note: "note quelconque",
        linkedinURL: "https://linkedin.com/in/janedoe",
        firstName: "Jane",
        lastName: "Doe",
        phone: "1234567890")))
}
