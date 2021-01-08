//
//  Test_Extensions.swift
//  PokemonsTests
//
//  Created by Maksym Humeniuk on 06.01.2021.
//

import XCTest
@testable import Pokemons

class Test_Extensions: XCTestCase {
    var lowercasedMessage: String?
    var firstLetterCapitalizedMessage: String?

    override func setUp() {
        lowercasedMessage = "test message"
        firstLetterCapitalizedMessage = "Test message"
    }
    
    func test_capitalizeFirstLetter_lowercasedString_comparsionWithCapitalizedResult() {
        XCTAssert(lowercasedMessage!.capitalizeFirstLetter == firstLetterCapitalizedMessage)
    }
    
    func test_capitalizeFirstLetter_capitalizedString_comparsionWithCapitalizedResult() {
        XCTAssert(firstLetterCapitalizedMessage!.capitalizeFirstLetter == firstLetterCapitalizedMessage)
    }
    
    func test_capitalizeFirstLetter_capitalizedString_comparsionWithLowercasedResult() {
        XCTAssert(firstLetterCapitalizedMessage!.capitalizeFirstLetter != lowercasedMessage)
    }
    
    override func tearDown() {
        lowercasedMessage = nil
        firstLetterCapitalizedMessage = nil
    }
}
