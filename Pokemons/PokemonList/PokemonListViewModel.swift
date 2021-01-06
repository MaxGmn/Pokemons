//
//  PokemonListViewModel.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 05.01.2021.
//

import RxSwift

protocol PokemonListViewModelProtocol {
    var items: PublishSubject<[PokemonListItem]> { get }
    var itemsCount: Int { get }
    func getinitialPageData()
    func getNextPageDataIfPresent()
    func getCellData(for index: Int) -> (name: String, link: String)
}

class PokemonListViewModel: PokemonListViewModelProtocol {
    private let dataService: PokemonDataServiceProtocol
    private let initialPageLink: String = "https://pokeapi.co/api/v2/pokemon"
    private var nextPageLink: String?
    private var _items: [PokemonListItem] = [] {
        didSet {
            self.items.onNext(_items)
        }
    }
    
    var items = PublishSubject<[PokemonListItem]>()
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
    
    func getCellData(for index: Int) -> (name: String, link: String) {
        let pokemon = _items[index]
        return (name: pokemon.name, link: pokemon.url)
    }
}
    
private extension PokemonListViewModel {
    func getData(for link: String?) {
        guard let unwrappedLink = link else { return }
        dataService.load(link: unwrappedLink) { [weak self] (result: Result<PokemonList, Error>) in
            switch result {
            case .success(let list):
                self?.nextPageLink = list.next
                self?._items.append(contentsOf: list.results)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
