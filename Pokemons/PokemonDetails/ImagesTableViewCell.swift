//
//  ImagesTableViewCell.swift
//  Pokemons
//
//  Created by Maksym Humeniuk on 05.01.2021.
//

import UIKit

class ImagesTableViewCell: UITableViewCell {
    private var collectionView: UICollectionView?
    private var images: [UIImage] = []
    private let cellId = "CollectionCell"
    private let maxImageSize: CGFloat = 100
        
    func configure(images: [UIImage]) {
        self.images = images
        addCollectionView()
        collectionView?.reloadData()
    }

    private func addCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let maxSize = getMaxImageSize()
        layout.itemSize = maxSize
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: maxSize.height),
                                          collectionViewLayout: layout)
        collectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else { return }
        self.contentView.addSubview(collectionView)
        
        contentView.addConstraints([
            contentView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
    
    private func getMaxImageSize() -> CGSize {
        let maxWidth = images.map { $0.size.width }.max() ?? 0
        let maxHeight = images.map { $0.size.height }.max() ?? 0
        return CGSize(width: maxWidth > maxImageSize ? maxImageSize : maxWidth,
                      height: maxHeight > maxImageSize ? maxImageSize : maxHeight)
    }
}

extension ImagesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: images[indexPath.row])
        return cell
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    func configure(with image: UIImage) {
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = image
        self.contentView.addSubview(imageView)
    }
}
