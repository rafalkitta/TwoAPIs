//
//  UIImageView+LoadingImage.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 10/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, completion: ((_ success: Bool) -> ())?) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion?(false)
                return
            }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion?(true)
            }
        }.resume()
    }
}
