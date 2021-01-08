//
//  FakePokemonDataService.swift
//  PokemonsTests
//
//  Created by Maksym Humeniuk on 06.01.2021.
//

import Foundation
@testable import Pokemons

enum FakePokemonLinks: String {
    case initialLink = "https://pokeapi.co/api/v2/pokemon"
    case nexpPageLink = "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20"
    case bulbasaurDetailsPage = "https://pokeapi.co/api/v2/pokemon/1"
    case spearowDetailsPage = "https://pokeapi.co/api/v2/pokemon/21"
    
    var dataSource: String {
        switch self {
        case .initialLink:
            return "initialPage"
        case .nexpPageLink:
            return "nextPage"
        case .bulbasaurDetailsPage:
            return "bulbasaurDetails"
        case .spearowDetailsPage:
            return "spearowDetails"
        }
    }
    
    var pokemonName: String {
        switch self {
        case .bulbasaurDetailsPage:
            return "bulbasaur"
        case .spearowDetailsPage:
            return "spearow"
        default:
            return ""
        }
    }
}

class FakePokemonDataService: PokemonDataServiceProtocol {
    func load<T:Decodable>(link: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let link = FakePokemonLinks(rawValue: link),
              let data = getData(link.dataSource),
              let result = try? JSONDecoder().decode(T.self, from: data) else {
            completion(.failure(NetworkError.unknownError))
            return
        }
        completion(.success(result))
    }
    
    func fetchData(for links: [String?], completion: @escaping ([Data]) -> Void) {
        completion([Data()])
    }
    
    private func getData(_ resource: String) -> Data? {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return nil }
        
        return data
    }
    
}
