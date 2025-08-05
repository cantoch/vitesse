//
//  CandidateUpdateView.swift
//  Vitesse
//
//  Created by Renaud Leroy on 31/07/2025.
//

import SwiftUI

struct CandidateUpdateView: View {
    @ObservedObject var viewModel: CandidateUpdateViewModel
    @State var showCandidateUpdateSuccess: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("\(viewModel.firstName) \(viewModel.lastName)")
            }
            .font(.title)
            .fontWeight(.bold)
            .padding(.bottom, 20)
            VStack(alignment: .leading) {
                Text("Phone")
                    .fontWeight(.bold)
                    .frame(width: 100, height: 30, alignment: .leading)
                TextField("", text: $viewModel.phone)
            }
            .padding(.bottom, 10)
            VStack(alignment: .leading) {
                Text("Email")
                    .fontWeight(.bold)
                    .frame(width: 100, height: 30, alignment: .leading)
                TextField("", text: $viewModel.email)
            }
            .padding(.bottom, 10)
            VStack(alignment: .leading) {
                Text("LinkedIn")
                    .fontWeight(.bold)
                    .frame(width: 100, height: 30, alignment: .leading)
                TextField("", text: $viewModel.linkedinURL)
            }
            .padding(.bottom, 10)
            VStack(alignment: .leading) {
                Text("Note")
                    .fontWeight(.bold)
                    .frame(width: 100, height: 30, alignment: .leading)
                TextField("", text: $viewModel.note)
            }
        }
        .padding(30)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    Task {
                        if let candidate = viewModel.candidate {
                            try? await viewModel.updateCandidate(candidate: candidate)
                            showCandidateUpdateSuccess.toggle()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}


//#Preview {
//    CandidateUpdateView()
//}
