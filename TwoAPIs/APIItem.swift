//
//  APIItem.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 10/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import Foundation

protocol APIItem {
    var userName: String { get }
    var avatarURL: URL { get }
    var sourceName: String { get }
}
