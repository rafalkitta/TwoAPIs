//
//  ViewController.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 09/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    private struct Const {
        static let shwoDetailsSegueIdentifier = "showDetails"
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    let usersProvider = UsersProvider()
    var items = [APIItem]()
    var selectedItem: APIItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersProvider.delegate = self
        usersProvider.loadData()
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Const.shwoDetailsSegueIdentifier,
            let destinationVC = segue.destination as? ItemDetailsViewController,
            let selectedItem = self.selectedItem {
            destinationVC.configure(with: selectedItem)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath)
        (cell as? ItemCollectionViewCell)?.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ItemsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = items[indexPath.item]
        performSegue(withIdentifier: Const.shwoDetailsSegueIdentifier, sender: self)
    }
}

// MARK: - UsersProviderDelegate
extension ItemsViewController: UsersProviderDelegate {
    func usersProvider(_ usersProvider: UsersProvider, didLoad users: [APIItem]) {
        items = users.shuffled()
        collectionView.reloadData()
    }
    
    func usersProviderDidFailLoadingUser(_ usersProvider: UsersProvider) {
        items.removeAll()
        collectionView.reloadData()
        let alert = UIAlertController(title: "Loading data error", message: "Couldn't load data", preferredStyle: .alert)
        present(alert, animated: true)
    }
}
