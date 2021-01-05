//
//  PokemonDataModel.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 04.01.2021.
//

import Foundation

struct PokemonList: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]
}

struct PokemonListItem: Decodable {
    let name: String
    let url: String
}
