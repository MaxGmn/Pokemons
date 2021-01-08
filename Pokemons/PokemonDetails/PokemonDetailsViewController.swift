//
//  PokemonDetailsViewController.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 05.01.2021.
//

import UIKit
import RxSwift

class PokemonDetailsViewController: UITableViewController {
    private let name: String
    private let link: String
    private let viewModel: PokemonDetailsViewModelProtocol
    private let disposeBag = DisposeBag()
    private let simpleCellId = "SimpleCell"
    private let imagesCellId = "ImagesCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: simpleCellId)
        tableView.register(ImagesTableViewCell.self, forCellReuseIdentifier: imagesCellId)
        tableView.allowsSelection = false
        self.navigationItem.title = name.capitalizeFirstLetter
        setup()        
    }
    
    init(name: String, link: String, viewModel: PokemonDetailsViewModelProtocol) {
        self.name = name
        self.link = link
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.details.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.details[section].itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.details[indexPath.section]
        let cell: UITableViewCell
        switch section {
        case .pictures(let picturesData):
            cell = tableView.dequeueReusableCell(withIdentifier: imagesCellId, for: indexPath)
            if let pictureCell = cell  as? ImagesTableViewCell {
                let images = picturesData.compactMap { UIImage(data: $0) }
                pictureCell.configure(images: images)
            }
        case .stats(let names), .types(let names):
            cell = tableView.dequeueReusableCell(withIdentifier: simpleCellId, for: indexPath)
            cell.textLabel?.text = names[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.details[section].title
    }
    
    private func setup() {
        viewModel.getDetails(for: link)
        
        viewModel.signal
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
