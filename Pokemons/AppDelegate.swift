//
//  AppDelegate.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 04.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()
        let dataService = PokemonDataService()
        let viewModel = PokemonListViewModel(dataService: dataService)
        let viewController = PokemonListViewController(viewModel: viewModel)
        navController.viewControllers.append(viewController)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }
}

