//
//  GitHubUser.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 10/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import Foundation

struct GitHubUser: APIItem, Decodable {
    let userName: String
    let avatarURL: URL
    let sourceName = "GutHub"
    
    private enum CodingKeys: String, CodingKey {
        case userName = "login"
        case avatarURL = "avatar_url"
    }
}
