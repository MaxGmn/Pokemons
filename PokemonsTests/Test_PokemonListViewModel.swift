//
//  Test_PokemonListViewModel.swift
//  PokemonsTests
//
//  Created by Maksym Humeniuk on 06.01.2021.
//

import XCTest
import RxSwift
import RxTest
@testable import Pokemons

class Test_PokemonListViewModel: XCTestCase {
    var dataService: PokemonDataServiceProtocol?
    var viewModel: PokemonListViewModel?
    var scheduler: TestScheduler?
    var disposeBag: DisposeBag?
    
    override func setUp() {
        dataService = FakePokemonDataService()
        viewModel = PokemonListViewModel(dataService: dataService!)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func test_getinitialPageData() {
        let list = scheduler!.createObserver([PokemonListItem].self)
        
        viewModel?.items
            .asObservable()
            .bind(to: list)
            .disposed(by: disposeBag!)
        
        viewModel?.getinitialPageData()
        
        scheduler!.start()
        
        XCTAssertEqual(list.events.count, 1)
        XCTAssertEqual(viewModel?.itemsCount, 20)
        
        guard let pokemonsList = list.events.last?.value.element,
              let firstPokemon = pokemonsList.first else {
            XCTFail()
            return
        }
        
        XCTAssert(firstPokemon.url.contains(FakePokemonLinks.bulbasaurDetailsPage.rawValue))
    }
    
    func test_getNextPageDataIfPresent_dataIsPresent() {
        let list = scheduler!.createObserver([PokemonListItem].self)
        
        viewModel?.items
            .asObservable()
            .bind(to: list)
            .disposed(by: disposeBag!)
        
        viewModel?.getinitialPageData()
        viewModel?.getNextPageDataIfPresent()
        
        scheduler!.start()
        
        XCTAssertEqual(list.events.count, 2)
        XCTAssertEqual(viewModel?.itemsCount, 40)

        guard let pokemonsList = list.events.last?.value.element,
              let firstPokemon = pokemonsList.first else {
            XCTFail()
            return
        }
        
        let twentyFirstPokemon = pokemonsList[20]
        XCTAssert(firstPokemon.url.contains(FakePokemonLinks.bulbasaurDetailsPage.rawValue))
        XCTAssert(twentyFirstPokemon.url.contains(FakePokemonLinks.spearowDetailsPage.rawValue))

    }
    
    func test_getCellData() {
        let list = scheduler!.createObserver([PokemonListItem].self)
        
        viewModel?.items
            .asObservable()
            .bind(to: list)
            .disposed(by: disposeBag!)
        
        viewModel?.getinitialPageData()
        viewModel?.getNextPageDataIfPresent()
        
        scheduler!.start()

        guard let pokemonsList = list.events.last?.value.element,
              let firstPokemon = pokemonsList.first,
              let firstPokemonData = viewModel?.getCellData(for: 0),
              let twentyFirstPokemonData = viewModel?.getCellData(for: 20) else {
            XCTFail()
            return
        }
        let twentyFirstPokemon = pokemonsList[20]
        XCTAssert(firstPokemon.url.contains(firstPokemonData.link))
        XCTAssert(firstPokemon.name.contains(firstPokemonData.name))
        XCTAssert(twentyFirstPokemon.url.contains(twentyFirstPokemonData.link))
        XCTAssert(twentyFirstPokemon.name.contains(twentyFirstPokemonData.name))        
    }

    override func tearDown() {
        dataService = nil
        viewModel = nil
        scheduler = nil
        disposeBag = nil
    }
}
