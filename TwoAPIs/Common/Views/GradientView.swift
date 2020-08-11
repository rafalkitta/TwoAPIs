//
//  GradientView.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 09/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override class var layerClass: AnyClass { CAGradientLayer.classForCoder() }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setColors([.black, .white], at: [0.0, 1.0])
    }
    
    func setColors(_ colors: [UIColor], at locations: [NSNumber]) {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.locations = locations
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
    }
}
