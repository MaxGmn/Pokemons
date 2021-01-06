//
//  PokemonDetailsModel.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 05.01.2021.
//

struct PokemonDetails: Codable {
    let name: String
    let sprites: Sprites
    let stats: [Stat]
    let types: [Type]
}

struct Sprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct Stat: Codable {
    let baseStat: Int
    let stat: Info
    
    private enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct Type: Codable {
    let type: Info
}

struct Info: Codable {
    let name: String
    let url: String
}
