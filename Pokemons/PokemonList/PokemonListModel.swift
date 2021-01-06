//
//  PokemonListModel.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 04.01.2021.
//

struct PokemonList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable {
    let name: String
    let url: String
}
