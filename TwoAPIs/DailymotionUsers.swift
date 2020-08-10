//
//  DailymotionUsers.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 10/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import Foundation

struct DailymotionUsers: Decodable {
    struct DailymotionUser: APIItem, Decodable {
        let userName: String
        let avatarURL: URL
        let sourceName = "Dailymotion"
        
        private enum CodingKeys: String, CodingKey {
            case userName = "username"
            case avatarURL = "avatar_360_url"
        }
    }
    
    let users: [DailymotionUser]
    
    private enum CodingKeys: String, CodingKey {
        case users = "list"
    }
}
