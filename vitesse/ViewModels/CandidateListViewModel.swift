//
//  CandidateListViewModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 19/07/2025.
//

import Foundation


class CandidateListViewModel: ObservableObject {
    
   
    let candidates: [Candidate] = [
        Candidate(phone: 830000001, note: "Je suis Alex Terrieur, un passionné d’aventures, de technologie et de rencontres inattendues. Ancien ingénieur reconverti en digital nomade, je vis pour explorer le monde, capturer l’instant avec mon drone, et lancer des idées qui sortent des sentiers battus. Curieux, créatif et toujours partant pour un défi, j’aime fédérer les énergies autour de projets qui ont du sens. Mon truc, c’est d’improviser, rebondir et faire sourire, même quand rien ne se passe comme prévu.", id: UUID(), firstName: "Alex", linkedinURL: "https://linkedin.com/in/alexterrieur", isFavorite: true, email: "alex.terrieur@example.com", lastName: "Terrieur"),
        Candidate(phone: 830000002, note: "1m65 55kg", id: UUID(), firstName: "Léa", linkedinURL: "https://linkedin.com/in/leadupuis", isFavorite: false, email: "lea.dupuis@example.com", lastName: "Dupuis"),
        Candidate(phone: 830000003, note: "1m82 85kg", id: UUID(), firstName: "Marc", linkedinURL: "https://linkedin.com/in/marcdelcourt", isFavorite: false, email: "marc.delcourt@example.com", lastName: "Delcourt"),
        Candidate(phone: 830000004, note: "1m60 50kg", id: UUID(), firstName: "Chloé", linkedinURL: "https://linkedin.com/in/chloemartin", isFavorite: true, email: "chloe.martin@example.com", lastName: "Martin"),
        Candidate(phone: 830000005, note: "1m75 75kg", id: UUID(), firstName: "Hugo", linkedinURL: "https://linkedin.com/in/hugofernandez", isFavorite: false, email: "hugo.fernandez@example.com", lastName: "Fernandez"),
        Candidate(phone: 830000006, note: "1m69 65kg", id: UUID(), firstName: "Camille", linkedinURL: "https://linkedin.com/in/camillepetit", isFavorite: false, email: "camille.petit@example.com", lastName: "Petit"),
        Candidate(phone: 830000007, note: "1m65 54kg", id: UUID(), firstName: "Emma", linkedinURL: "https://linkedin.com/in/emmagarnier", isFavorite: false, email: "emma.garnier@example.com", lastName: "Garnier"),
        Candidate(phone: 830000008, note: "1m85 85kg", id: UUID(), firstName: "Bruno", linkedinURL: "https://linkedin.com/in/brunofaure", isFavorite: true, email: "bruno.faure@example.com", lastName: "Faure"),
        Candidate(phone: 830000009, note: "1m70 65kg", id: UUID(), firstName: "Julie", linkedinURL: "https://linkedin.com/in/juliemercier", isFavorite: false, email: "julie.mercier@example.com", lastName: "Mercier"),
        Candidate(phone: 830000010, note: "1m76 72kg", id: UUID(), firstName: "Maxime", linkedinURL: "https://linkedin.com/in/maximeleroy", isFavorite: true, email: "maxime.leroy@example.com", lastName: "Leroy")
    ]
}


