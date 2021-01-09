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
        let list = scheduler!.createObserver([PokemonItem].self)
        let expect = expectation(description: "items")
        
        viewModel?.items
            .asObservable()
            .bind(to: list)
            .disposed(by: disposeBag!)
        
        viewModel?.getinitialPageData()
        
        scheduler!.start()
        
        viewModel?.items
            .subscribe(onNext: { _ in
                expect.fulfill()
            })
            .disposed(by: disposeBag!)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(list.events.count, 1)
        XCTAssertEqual(viewModel?.itemsCount, 1)
        
        guard let pokemonsList = list.events.last?.value.element,
              let firstPokemon = pokemonsList.first else {
            XCTFail()
            return
        }
        
        XCTAssert(firstPokemon.name.contains(FakePokemonLinks.bulbasaurDetailsPage.pokemonName))
        XCTAssert(firstPokemon.details.name.contains(FakePokemonLinks.bulbasaurDetailsPage.pokemonName))
    }
    
    func test_getNextPageDataIfPresent_dataIsPresent() {
        let list = scheduler!.createObserver([PokemonItem].self)
        let expect = expectation(description: "items")

        viewModel?.items
            .asObservable()
            .bind(to: list)
            .disposed(by: disposeBag!)
        
        viewModel?.getinitialPageData()
        viewModel?.getNextPageDataIfPresent()
        
        scheduler!.start()
        
        viewModel?.items
            .element(at: 1)
            .subscribe(onNext: { _ in
            expect.fulfill()
        })
            .disposed(by: disposeBag!)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(list.events.count, 2)
        XCTAssertEqual(viewModel?.itemsCount, 2)

        guard let pokemonsList = list.events.last?.value.element,
              let firstPokemon = pokemonsList.first else {
            XCTFail()
            return
        }
        
        let twentyFirstPokemon = pokemonsList[1]
        XCTAssert(firstPokemon.name.contains(FakePokemonLinks.bulbasaurDetailsPage.pokemonName))
        XCTAssert(firstPokemon.details.name.contains(FakePokemonLinks.bulbasaurDetailsPage.pokemonName))
        XCTAssert(twentyFirstPokemon.name.contains(FakePokemonLinks.spearowDetailsPage.pokemonName))
        XCTAssert(twentyFirstPokemon.details.name.contains(FakePokemonLinks.spearowDetailsPage.pokemonName))
    }
    
    func test_getCellData() {
        let list = scheduler!.createObserver([PokemonItem].self)
        let expect = expectation(description: "items")
        
        viewModel?.items
            .asObservable()
            .bind(to: list)
            .disposed(by: disposeBag!)
        
        viewModel?.getinitialPageData()
        viewModel?.getNextPageDataIfPresent()
        
        scheduler!.start()
        
        viewModel?.items
            .element(at: 1)
            .subscribe(onNext: { _ in
            expect.fulfill()
        })
            .disposed(by: disposeBag!)
        
        waitForExpectations(timeout: 5, handler: nil)

        guard let pokemonsList = list.events.last?.value.element,
              let firstPokemon = pokemonsList.first,
              let firstPokemonData = viewModel?.getCellData(for: 0),
              let twentyFirstPokemonData = viewModel?.getCellData(for: 1) else {
            XCTFail()
            return
        }
        let twentyFirstPokemon = pokemonsList[1]
        XCTAssert(firstPokemon.name.contains(firstPokemonData.name))
        XCTAssert(firstPokemon.details.name.contains(firstPokemonData.name))
        XCTAssert(twentyFirstPokemon.name.contains(twentyFirstPokemonData.name))
        XCTAssert(twentyFirstPokemon.details.name.contains(twentyFirstPokemonData.name))
    }

    override func tearDown() {
        dataService = nil
        viewModel = nil
        scheduler = nil
        disposeBag = nil
    }
}
