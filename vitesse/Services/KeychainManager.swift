//
//  KeychainManager.swift
//  Vitesse
//
//  Created by Renaud Leroy on 12/07/2025.
//

import Foundation
import Security


class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    func save(key: String, value: String) {
        let data = value.data(using: .utf8)!   // Convertit la String en Data avec l’encodage UTF-8, obligatoire pour le Keychain.
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,   // type d’élément (ici, mot de passe générique)
            kSecAttrAccount as String: key,   // identifiant (clé unique)
            kSecValueData as String: data   // La donnée à stocker
        ]
        SecItemDelete(query as CFDictionary)   // Supprime toute entrée existante avec la même clé pour éviter les doublons
        SecItemAdd(query as CFDictionary, nil)   // Ajoute la nouvelle entrée dans le Keychain
    }
    
    func read(key: String) -> String? {   // Méthode pour lire une valeur stockée avec une certaine clé
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne   // Limiter à une seule correspondance
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}


