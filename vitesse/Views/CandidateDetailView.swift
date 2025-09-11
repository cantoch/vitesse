//
//  CandidateDetailView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 19/07/2025.
//

import SwiftUI

struct CandidateDetailView: View {
    @State private var candidate: Candidate
    @State var isFavorite: Bool
    @State var isAdmin: Bool = false
    @State var goEdit: Bool = false
    
    @ObservedObject var viewModel = CandidateDetailViewModel()
    
    init(candidate: Candidate) {
        _candidate = .init(initialValue: candidate)
        _isFavorite = .init(initialValue: candidate.isFavorite)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(candidate.firstName) \(candidate.lastName)")
                Spacer()
                Button {
                    Task {
                        if let isAdminValue = KeychainManager.shared.read(key: "AuthStatus") {
                            isAdmin = (isAdminValue == "true")
                        }
                        
                        if isAdmin {
                            try? await viewModel.favoriteCandidate(candidate: candidate)
                            isFavorite.toggle()
                        }
                    }
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                }
            }
            .font(.title)
            .fontWeight(.bold)
            .padding(.bottom, 40)
            HStack {
                Text("Phone")
                    .fontWeight(.bold)
                    .frame(width: 100, height: 30, alignment: .leading)
                Text(candidate.phone)
                Spacer()
            }
            .padding(.bottom, 10)
            HStack {
                Text("Email")
                    .fontWeight(.bold)
                    .frame(width: 100, height: 30, alignment: .leading)
                Text(candidate.email)
                Spacer()
            }
            .padding(.bottom, 10)
            HStack {
                Text("LinkedIn")
                    .fontWeight(.bold)
                    .frame(width: 100, height: 30, alignment: .leading)
                Button("Go on LinkedIn") {
                }
                .frame(width: 120, height: 30)
                .foregroundStyle(Color.white)
                .cornerRadius(5)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                Spacer()
            }
            .padding(.bottom, 10)
            VStack(alignment: .leading) {
                Text("Note")
                    .fontWeight(.bold)
                    .frame(width: 100, height: 30, alignment: .leading)
                Text(candidate.note)
            }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") { goEdit = true }
                    .navigationDestination(isPresented: $goEdit) {
                        CandidateUpdateView(
                            viewModel: CandidateUpdateViewModel(candidate: candidate),
                            onUpdated: { updated in
                                candidate = updated
                                isFavorite = updated.isFavorite
                            }
                        )
                    }
            }
        }
        .padding(30)
    }
}

#Preview {
    CandidateDetailView(candidate: Candidate(
        phone: "1234567890",
        note: "Excellent communication skills.",
        id: UUID(),
        firstName: "John",
        linkedinURL: "https://linkedin.com/in/johndoe",
        isFavorite: true,
        email: "john.doe@example.com",
        lastName: "Doe"
    ))
}


