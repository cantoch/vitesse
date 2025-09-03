//
//  CandidateListView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 19/07/2025.
//

import SwiftUI

struct CandidateListView: View {
    @Binding var isLoggedIn: Bool
    @State var searchText: String = ""
    @State var showFavorites: Bool = false
    @State var goCreationCandidate: Bool = false
    @ObservedObject var viewModel: CandidateListViewModel
    @State private var showAlertLogout: Bool = false
    
    private var filteredCandidates: [Candidate] {
        viewModel.candidates.filter { (searchText.isEmpty || $0.lastName.localizedStandardContains(searchText) || $0.firstName.localizedStandardContains(searchText)) && (!showFavorites || $0.isFavorite)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredCandidates) { candidate in
                        NavigationLink(destination: CandidateDetailView(candidate: candidate)) {
                            HStack {
                                Text("\(candidate.firstName) \(candidate.lastName)")
                                Spacer()
                                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                            }
                        }
                    }
                    .onDelete { indices in
                        Task {
                            await viewModel.deleteCandidate(at: indices)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher un candidat")
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .navigationTitle(Text("Candidats"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showFavorites.toggle()
                        }) {Image(systemName: showFavorites ? "star.fill" : "star")}
                        Spacer(minLength: 14)
                        Button(action: {
                            showAlertLogout = true}) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                            }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Ajouter un candidat") {
                        goCreationCandidate.toggle()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            do {
                try await viewModel.getAllCandidates()
            }
            catch {
                print("Error fetching candidates: \(error)")
            }
        }
        .alert("Voulez-vous vous déconnecter ?", isPresented: $showAlertLogout) {
            Button("Se déconnecter", role: .destructive) {
                isLoggedIn = false
            }
            Button("Annuler", role: .cancel) { }
        }
        .sheet(
            isPresented: $goCreationCandidate,
            onDismiss: {
                Task {
                    do {
                        try await viewModel.getAllCandidates()
                    } catch {
                        print("Error fetching candidates: \(error)")
                    }
                }
            }
        ) {
            let emptyRequest = CandidateRequest(
                email: "",
                note: "",
                linkedinURL: "",
                firstName: "",
                lastName: "",
                phone: ""
            )
            CandidateCreationView(
                viewModel: CandidateCreationViewModel(
                    candidate: emptyRequest,
                    keychainManager: KeychainManager.shared,
                    api: DefaultAPIClient()
                )
            )
        }
    }
}
