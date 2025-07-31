//
//  CandidateListView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 19/07/2025.
//

import SwiftUI

struct CandidateListView: View {
    @State var searchText: String = ""
    @State var showFavorites: Bool = false
    
    @ObservedObject var viewModel = CandidateListViewModel()
    
    var body: some View {
        
        let filteredCandidates = viewModel.candidates.filter { (searchText.isEmpty || $0.lastName.localizedStandardContains(searchText) || $0.firstName.localizedStandardContains(searchText)) && (!showFavorites || $0.isFavorite)
        }
        
        NavigationView {
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
                }
            }
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Edit")
                }
                ToolbarItem(placement: .principal) {
                    Text("Candidats")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showFavorites.toggle()
                    }) {Image(systemName: showFavorites ? "star.fill" : "star")}
                }
            }
            .task {
                do {
                    try await viewModel.getAllCandidates()
                }
                catch {
                    print("Error fetching candidates: \(error)")
                }
            }
        }
    }
}


#Preview {
    CandidateListView()
}
