//
//  Test_PokemonDetailsViewModel.swift
//  PokemonsTests
//
//  Created by Maksym Humeniuk on 06.01.2021.
//

import XCTest
import RxTest
import RxSwift
@testable import Pokemons

class Test_PokemonDetailsViewModel: XCTestCase {
    var dataService: PokemonDataServiceProtocol?
    var viewModel: PokemonDetailsViewModel?
    var scheduler: TestScheduler?
    var disposeBag: DisposeBag?

    override func setUp() {
        dataService = FakePokemonDataService()
        viewModel = PokemonDetailsViewModel(dataService: dataService!)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    func test_getDetails_firstPokemon() {
        let signal = scheduler!.createObserver(Void.self)
        
        viewModel?.signal
            .asObservable()
            .bind(to: signal)
            .disposed(by: disposeBag!)
        
        viewModel?.getDetails(for: FakePokemonLinks.bulbasaurDetailsPage.rawValue)
        
        scheduler!.start()
        
        guard !signal.events.isEmpty else {
            XCTFail()
            return
        }
        
        viewModel?.details.forEach {
            switch $0 {
            case .pictures(let data):
                XCTAssertEqual(data.count, 1)
            case .stats(let stats):
                XCTAssertEqual(stats.count, 6)
                XCTAssertTrue(stats.contains("hp: 45"))
                XCTAssertTrue(stats.contains("attack: 49"))
                XCTAssertTrue(stats.contains("defense: 49"))
                XCTAssertTrue(stats.contains("special-attack: 65"))
                XCTAssertTrue(stats.contains("special-defense: 65"))
                XCTAssertTrue(stats.contains("speed: 45"))
            case .types(let types):
                XCTAssertEqual(types.count, 2)
                XCTAssertTrue(types.contains("grass"))
                XCTAssertTrue(types.contains("poison"))
            }
        }
    }
    
    func test_getDetails_twentyFirstPokemon() {
        let signal = scheduler!.createObserver(Void.self)
        
        viewModel?.signal
            .asObservable()
            .bind(to: signal)
            .disposed(by: disposeBag!)
        
        viewModel?.getDetails(for: FakePokemonLinks.spearowDetailsPage.rawValue)
        
        scheduler!.start()
        
        guard !signal.events.isEmpty else {
            XCTFail()
            return
        }
        
        viewModel?.details.forEach {
            switch $0 {
            case .pictures(let data):
                XCTAssertEqual(data.count, 1)
            case .stats(let stats):
                XCTAssertEqual(stats.count, 6)
                XCTAssertTrue(stats.contains("hp: 40"))
                XCTAssertTrue(stats.contains("attack: 60"))
                XCTAssertTrue(stats.contains("defense: 30"))
                XCTAssertTrue(stats.contains("special-attack: 31"))
                XCTAssertTrue(stats.contains("special-defense: 31"))
                XCTAssertTrue(stats.contains("speed: 70"))
            case .types(let types):
                XCTAssertEqual(types.count, 2)
                XCTAssertTrue(types.contains("normal"))
                XCTAssertTrue(types.contains("flying"))
            }
        }
    }
    
    override func tearDown() {
        dataService = nil
        viewModel = nil
        scheduler = nil
        disposeBag = nil
    }
}
