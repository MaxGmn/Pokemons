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
    func load<T:Codable>(link: String, completion: @escaping (Result<T, Error>) -> Void)
    func fetchData(for links: [String?], completion: @escaping ([Data]) -> Void)
}

class PokemonDataService: PokemonDataServiceProtocol {
    private let offlineStorage: PokemonOfflineStorageProtocol
    
    init(offlineStorage: PokemonOfflineStorageProtocol) {
        self.offlineStorage = offlineStorage
    }
    
    func load<T:Codable>(link: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: link) else {
            completion(.failure(NetworkError.incorrectUrl))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data, let result = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(result))
                self?.offlineStorage.set(data: result, for: link)
                return
            }
            
            if let data: T = self?.offlineStorage.get(by: link) {
                completion(.success(data))
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
            
            let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data,_,_ in
                if let data = data {
                    dataArray.append(data)
                    self?.offlineStorage.set(data: data, for: link)
                } else if let data: Data = self?.offlineStorage.get(by: link) {
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
