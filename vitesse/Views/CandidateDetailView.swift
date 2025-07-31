//
//  CandidateDetailView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 19/07/2025.
//

import SwiftUI

struct CandidateDetailView: View {
    @State var isFavorite: Bool
    @State var isAdmin: Bool = false
    @State var goEdit: Bool = false
    
    @ObservedObject var viewModel = CandidateDetailViewModel()
    
    let candidate: Candidate
    
    init(candidate: Candidate) {
        _isFavorite = .init(initialValue: candidate.isFavorite)
        self.candidate = candidate
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
                Text(String(candidate.phone))
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
                Button("Edit") {
                    goEdit = true
                }
                .navigationDestination(isPresented: $goEdit) {
                    CandidateUpdateView(viewModel: CandidateUpdateViewModel(candidate: candidate))
                }
            }
        }
        .padding(30)
    }
}



