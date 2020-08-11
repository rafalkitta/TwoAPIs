//
//  ItemCollectionViewCell.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 09/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.alpha = 0.0
        }
    }
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var footerOverlay: GradientView! {
        didSet {
            let gradientColors = [UIColor.black.withAlphaComponent(0.7),
                                  UIColor.black.withAlphaComponent(0.3),
                                  UIColor.black.withAlphaComponent(0.0)]
            footerOverlay.setColors(gradientColors, at: [0.0, 0.7, 1.0])
        }
    }
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        avatarImageView.alpha = 0.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8.0
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func configure(with item: APIItem) {
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
