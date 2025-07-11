//
//  AuthenticationViewModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    let apiService = VitesseAPIService()
}
