//
//  GitHubUsersService.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 10/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import Foundation

class GitHubUsersService: APIService {
    typealias ItemType = GitHubUser
    let url: URL
    
    init(url: URL = URL(string: "https://api.github.com/users")!) {
        self.url = url
    }
    
    func load(completion: @escaping (Result<[GitHubUser], APIServiceError>) -> Void) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(APIServiceError.networkingError(error!)))
                return
            }
            guard let data = data else {
                completion(.failure(APIServiceError.noData))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([GitHubUser].self, from: data)
                completion(.success(users))
                
            } catch let decodingError {
                completion(.failure(APIServiceError.decodingError(decodingError)))
            }
        }.resume()
    }
}
