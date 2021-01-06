//
//  Extensions.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 05.01.2021.
//

extension String {
    var capitalizeFirstLetter: String {
        guard let firstLetter = self.first?.uppercased() else { return self }
        return firstLetter + self.dropFirst()
    }
}
