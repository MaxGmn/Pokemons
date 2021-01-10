//
//  PokemonListViewModel.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 05.01.2021.
//

import Foundation
import RxSwift

struct PokemonItem {
    let name: String
    let details: PokemonDetails
    let imageData: Data?
}

protocol PokemonListViewModelProtocol {
    var items: PublishSubject<[PokemonItem]> { get }
    var itemsCount: Int { get }
    func getinitialPageData()
    func getNextPageDataIfPresent()
    func getCellData(for index: Int) -> PokemonDetails
}

class PokemonListViewModel: PokemonListViewModelProtocol {
    private let dataService: PokemonDataServiceProtocol
    private let initialPageLink: String = "https://pokeapi.co/api/v2/pokemon"
    private var nextPageLink: String?
    private var _items: [PokemonItem] = [] {
        didSet {
            self.items.onNext(_items)
        }
    }
    
    var items = PublishSubject<[PokemonItem]>()
    var itemsCount: Int {
        _items.count
    }
    
    init(dataService: PokemonDataServiceProtocol) {
        self.dataService = dataService
    }
    
    func getinitialPageData() {
        getData(for: initialPageLink)
    }
    
    func getNextPageDataIfPresent() {
        getData(for: nextPageLink)
    }
    
    func getCellData(for index: Int) -> PokemonDetails {
        return _items[index].details
    }
}
    
private extension PokemonListViewModel {
    func getData(for link: String?) {
        guard let unwrappedLink = link else { return }
        dataService.load(link: unwrappedLink) { [weak self] (result: Result<PokemonList, Error>) in
            switch result {
            case .success(let list):
                self?.nextPageLink = list.next
                let urlList = list.results.map{ $0.url }
                self?.fetchItemsData(links: urlList)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func fetchItemsData(links: [String]){
        let group = DispatchGroup()
        var pokemonItems: [PokemonItem] = []
        
        links.forEach { link in
            group.enter()
            self.dataService.load(link: link) { [weak self] (result: Result<PokemonDetails, Error>) in
                switch result {
                case .success(let details):
                    let linkToImage = details.sprites.front_default ?? ""
                    self?.dataService.fetchData(for: [linkToImage]) { data in
                        if let imageData = data.first {
                            pokemonItems.append(PokemonItem(name: details.name, details: details, imageData: imageData))
                        }
                        group.leave()
                    }
                case .failure:
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?._items.append(contentsOf: pokemonItems)
        }
        
    }
}
