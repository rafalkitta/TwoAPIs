//
//  ItemDetailsViewController.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 11/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    @IBOutlet private weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.alpha = 0.0
        }
    }
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    func configure(with item: APIItem) {
        loadViewIfNeeded()
        userNameLabel.text = item.userName
        sourceLabel.text = item.sourceName
        activityIndicator.startAnimating()
        avatarImageView.loadImage(from: item.avatarURL) { success in
            guard success else { return }
            self.activityIndicator.stopAnimating()
            UIView.animate(withDuration: 0.3) {
                self.avatarImageView.alpha = 1.0
            }
        }
    }
}
