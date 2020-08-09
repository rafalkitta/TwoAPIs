//
//  ViewController.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 09/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateItemSize()
    }
    
    private func updateItemSize() {
        let cellsPerRow = 2
        let safeAreaInsets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            safeAreaInsets = view.safeAreaInsets
        } else {
            safeAreaInsets = .zero
        }
        let marginsAndInsets = collectionViewFlowLayout.sectionInset.left +
            collectionViewFlowLayout.sectionInset.right +
            safeAreaInsets.left + safeAreaInsets.right +
            collectionViewFlowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((view.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        collectionViewFlowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth)
    }
}

// MARK: - UICollectionViewDataSource
extension ItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath)
        return cell
    }
}
