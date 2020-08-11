//
//  APIService.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 10/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import Foundation

enum APIServiceError: Error {
    case noData
    case networkingError(Error)
    case decodingError(Error)
}

protocol APIService {
    associatedtype ItemType: Decodable, APIItem
    func load(completion: @escaping (Result<[ItemType], APIServiceError>) -> Void)
}
