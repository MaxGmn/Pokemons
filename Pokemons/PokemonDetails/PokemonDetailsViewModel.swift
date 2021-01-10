//
//  PokemonDetailsViewModel.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 05.01.2021.
//

import Foundation
import RxSwift

enum Details {
    case pictures([Data])
    case stats([String])
    case types([String])
    
    var itemsCount: Int {
        switch self{
        case .pictures:
            return 1
        case .stats(let items), .types(let items):
            return items.count
        }
    }
    
    var title: String {
        switch self {
        case .pictures:
            return "Pictures"
        case .stats:
            return "Stats"
        case .types:
            return "Types"
        }
    }
}

protocol PokemonDetailsViewModelProtocol {
    var details: [Details] { get }
    var signal: PublishSubject<Void> { get }
    func getDetails()
}

class PokemonDetailsViewModel: PokemonDetailsViewModelProtocol {
    private let dataService: PokemonDataServiceProtocol
    private let pokemonDetails: PokemonDetails
    
    var details: [Details] = [] {
        didSet {
            signal.onNext(())
        }
    }
    let signal = PublishSubject<Void>()
    
    init(pokemonDetails: PokemonDetails, dataService: PokemonDataServiceProtocol) {
        self.pokemonDetails = pokemonDetails
        self.dataService = dataService
    }
    
    func getDetails() {
        fetchFullDetailsData(pokemonDetails)
    }
    
    private func fetchFullDetailsData(_ pokemonDetails: PokemonDetails) {
        let mirror = Mirror(reflecting: pokemonDetails.sprites)
        let links = mirror.children.map{ $0.value as? String }
        dataService.fetchData(for: links) { [weak self] imagesData in
            let stats = pokemonDetails.stats.map{ "\($0.stat.name): \($0.baseStat)" }
            let types = pokemonDetails.types.map{ $0.type.name }
            self?.details = [.pictures(imagesData), .stats(stats), .types(types)]
        }
    }
}
