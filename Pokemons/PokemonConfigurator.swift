//
//  PokemonConfigurator.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 06.01.2021.
//

import UIKit

class PokemonConfigurator {
    static let shared = PokemonConfigurator()
    private let dataService = PokemonDataService()
    
    private init() {}
    
    func getRootController() -> UIViewController {
        let navController = UINavigationController()
        let viewModel = PokemonListViewModel(dataService: dataService)
        let viewController = PokemonListViewController(viewModel: viewModel)
        navController.viewControllers.append(viewController)
        return navController
    }
    
    func getDetailsController(name: String, link: String) -> UIViewController {
        let detailsViewModel = PokemonDetailsViewModel(dataService: dataService)
        let detailsViewController = PokemonDetailsViewController(name: name, link: link, viewModel: detailsViewModel)
        return detailsViewController
    }
}
