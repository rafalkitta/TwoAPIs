//
//  DailymotionUsersService.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 10/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import Foundation

struct DailymotionUsersService: APIService {
    typealias ItemType = DailymotionUsers.DailymotionUser
    let url: URL

    init(url: URL = URL(string: "https://api.dailymotion.com/users?fields=avatar_360_url,username")!) {
        self.url = url
    }
    
    func load(completion: @escaping (Result<[DailymotionUsers.DailymotionUser], APIServiceError>) -> Void) {
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
                let usersResponse = try JSONDecoder().decode(DailymotionUsers.self, from: data)
                completion(.success(usersResponse.users))
                
            } catch let decodingError {
                completion(.failure(APIServiceError.decodingError(decodingError)))
            }
        }.resume()
    }
}
