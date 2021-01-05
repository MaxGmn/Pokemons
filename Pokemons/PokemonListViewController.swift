//
//  PokemonListViewController.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 04.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonListViewController: UIViewController {
    private let viewModel: PokemonListViewModelProtocol
    private let disposeBag = DisposeBag()
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()

    init(viewModel: PokemonListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        setup()
    }    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
private extension PokemonListViewController {
    func buildUI() {
        self.navigationItem.title = "Pokemons List"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        view.addConstraints([
            tableView.topAnchor.constraint(equalTo: margins.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    func setup() {
        viewModel.getinitialPageData()
        
        viewModel.items
            .bind(to: tableView.rx.items) { tableView, _, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
                cell.textLabel?.text = item.name.capitalizeFirstLetter
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.showDetails(for: indexPath.row)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .subscribe(onNext: { [weak self] indexPaths in
                guard let self = self, indexPaths.last?.row == self.viewModel.itemsCount - 1 else { return }
                self.viewModel.getNextPageDataIfPresent()
            })
            .disposed(by: disposeBag)
    }
}


