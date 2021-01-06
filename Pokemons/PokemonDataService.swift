//
//  PokemonDataService.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 04.01.2021.
//

import Foundation

enum NetworkError: Error {
    case incorrectUrl
    case unknownError
}

protocol PokemonDataServiceProtocol {
    func load<T:Decodable>(link: String, completion: @escaping (Result<T, Error>) -> Void)
    func fetchData(for links: [String?], completion: @escaping ([Data]) -> Void)
}

class PokemonDataService: PokemonDataServiceProtocol {
    func load<T:Decodable>(link: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: link) else {
            completion(.failure(NetworkError.incorrectUrl))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let result = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(result))
                return
            }
            
            guard let error = error else {
                completion(.failure(NetworkError.unknownError))
                return
            }
            completion(.failure(error))
        }
        
        dataTask.resume()
    }
    
    func fetchData(for links: [String?], completion: @escaping ([Data]) -> Void) {
        var dataArray: [Data] = []
        let group = DispatchGroup()
        
        links.forEach {
            guard let link = $0, let url = URL(string: link) else { return }
            group.enter()
            
            let dataTask = URLSession.shared.dataTask(with: url) { data,_,_ in
                if let data = data {
                    dataArray.append(data)
                }
                group.leave()
            }
            
            dataTask.resume()
        }
        
        group.notify(queue: .main) {
            completion(dataArray)
        }
    }
}
