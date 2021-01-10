//
//  PokemonConfigurator.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 06.01.2021.
//

import UIKit

class PokemonConfigurator {
    static let shared = PokemonConfigurator()
    private let dataService: PokemonDataServiceProtocol
    
    private init() {
        let offlineStorage = PokemonOfflineStorage()
        dataService = PokemonDataService(offlineStorage: offlineStorage)
    }
    
    func getRootController() -> UIViewController {
        let navController = UINavigationController()
        let viewModel = PokemonListViewModel(dataService: dataService)
        let viewController = PokemonListViewController(viewModel: viewModel)
        navController.viewControllers.append(viewController)
        return navController
    }
    
    func getDetailsController(with pokemonDetails: PokemonDetails) -> UIViewController {
        let detailsViewModel = PokemonDetailsViewModel(pokemonDetails: pokemonDetails, dataService: dataService)
        let detailsViewController = PokemonDetailsViewController(name: pokemonDetails.name, viewModel: detailsViewModel)
        return detailsViewController
    }
}
