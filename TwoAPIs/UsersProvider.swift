//
//  UsersProvider.swift
//  TwoAPIs
//
//  Created by Rafał Kitta on 10/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import Foundation

protocol UsersProviderDelegate: class {
    func usersProvider(_ usersProvider: UsersProvider, didLoad users: [APIItem])
    func usersProviderDidFailLoadingUser(_ usersProvider: UsersProvider)
}

class UsersProvider {
    enum FailureStrategy {
        case anyFails
        case allFails
    }
    
    let gitHubUsersService: GitHubUsersService
    let dailymotionUsersService: DailymotionUsersService
    var failureStrategy: FailureStrategy = .anyFails
    
    weak var delegate: UsersProviderDelegate?
    
    init(gitHubUsersService: GitHubUsersService = GitHubUsersService(),
         dailymotionUsersService: DailymotionUsersService = DailymotionUsersService()) {
        self.gitHubUsersService = gitHubUsersService
        self.dailymotionUsersService = dailymotionUsersService
    }
    
    func loadData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        var gitHubResult: Result<[GitHubUser], APIServiceError>?
        gitHubUsersService.load { (result) in
            gitHubResult = result
            if case let .failure(gitHubError) = result {
                print("Loading data from github failed: \(gitHubError)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        var dailymotionResult: Result<[DailymotionUsers.DailymotionUser], APIServiceError>?
        dailymotionUsersService.load { (result) in
            dailymotionResult = result
            if case let .failure(dailymotionError) = result {
                print("Loading data from dailymotion failed: \(dailymotionError)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            switch (gitHubResult, dailymotionResult, self.failureStrategy) {
            case (.failure, .failure, _), (_, .failure, .anyFails), (.failure, _, .anyFails):
                self.delegate?.usersProviderDidFailLoadingUser(self)
            default:
                var users = [APIItem]()
                if let gitHubUsers = try? gitHubResult?.get() {
                    users.append(contentsOf: gitHubUsers)
                }
                if let dailymotionUsers = try? dailymotionResult?.get() {
                    users.append(contentsOf: dailymotionUsers)
                }
                self.delegate?.usersProvider(self, didLoad: users)
            }
        }
    }
}
