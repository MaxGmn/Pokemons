//
//  PokemonOfflineStorage.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 06.01.2021.
//

import Foundation

protocol PokemonOfflineStorageProtocol {
    func set<T:Codable>(data: T, for key: String)
    func get<T:Codable>(by key: String) -> T?
}

class PokemonOfflineStorage: PokemonOfflineStorageProtocol {
    private let defaults = UserDefaults.standard
    
    func set<T:Codable>(data: T, for key: String) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(data) else { return }
        defaults.setValue(encoded, forKey: key)
    }
    
    func get<T:Codable>(by key: String) -> T? {
        let decoder = JSONDecoder()
        guard let data = defaults.value(forKey: key) as? Data,
              let uncodedData = try? decoder.decode(T.self, from: data)  else { return nil }
        
        return uncodedData
    }
}
