//
//  UsersProviderTests.swift
//  TwoAPIsTests
//
//  Created by Rafał Kitta on 11/08/2020.
//  Copyright © 2020 Rafał Kitta. All rights reserved.
//

import XCTest
@testable import TwoAPIs

class UsersProviderTests: XCTestCase {
    private class GitHubUserServiceMock: GitHubUsersService {
        private let result: Result<[GitHubUser], APIServiceError>
        
        init(result: Result<[GitHubUser], APIServiceError>) {
            self.result = result
        }
        
        override func load(completion: @escaping (Result<[GitHubUser], APIServiceError>) -> Void) {
            completion(result)
        }
    }
    
    private class DailymotionUserServiceMock: DailymotionUsersService {
        private let result: Result<[DailymotionUsers.DailymotionUser], APIServiceError>
        
        init(result: Result<[DailymotionUsers.DailymotionUser], APIServiceError>) {
            self.result = result
        }
        
        override func load(completion: @escaping (Result<[DailymotionUsers.DailymotionUser], APIServiceError>) -> Void) {
            completion(result)
        }
    }
    
    private class ClosureDelegate: UsersProviderDelegate {
        var didLoadClousure: ((_ usersProvider: UsersProvider, _ users: [APIItem]) -> Void)?
        var didFailClousure: ((_ usersProvider: UsersProvider) -> Void)?
        
        func usersProvider(_ usersProvider: UsersProvider, didLoad users: [APIItem]) {
            didLoadClousure?(usersProvider, users)
        }
        func usersProviderDidFailLoadingUser(_ usersProvider: UsersProvider) {
            didFailClousure?(usersProvider)
        }
    }
    
    func testReturnsBothTypesOfUsers() {
        let gitHubUser = GitHubUser(userName: "gitHubUser", avatarURL: URL(string: "https://apple.com")!)
        let dailymotionUser = DailymotionUsers.DailymotionUser(userName: "dailymotionUser", avatarURL: URL(string: "https://google.com")!)
        let gitHubServiceMock = GitHubUserServiceMock(result: .success([gitHubUser]))
        let dailymotionServiceMock = DailymotionUserServiceMock(result: .success([dailymotionUser]))
        let delegate = ClosureDelegate()
        delegate.didLoadClousure = { (_, users) in
            XCTAssertEqual(users.count, 2)
            XCTAssertTrue(users.contains(where: { $0.userName == "gitHubUser" }))
            XCTAssertTrue(users.contains(where: { $0.userName == "dailymotionUser" }))
        }
        delegate.didFailClousure = { (_) in
            XCTFail()
        }
        let sut = UsersProvider(gitHubUsersService: gitHubServiceMock, dailymotionUsersService: dailymotionServiceMock)
        sut.delegate = delegate
        
        sut.loadData()
    }
    
    func testFailsWhenNoUsers() {
        let gitHubServiceMock = GitHubUserServiceMock(result: .failure(APIServiceError.noData))
        let dailymotionServiceMock = DailymotionUserServiceMock(result: .failure(APIServiceError.noData))
        let delegate = ClosureDelegate()
        delegate.didLoadClousure = { (_, users) in
            XCTFail()
        }
        let sut = UsersProvider(gitHubUsersService: gitHubServiceMock, dailymotionUsersService: dailymotionServiceMock)
        sut.delegate = delegate
        
        sut.loadData()
    }
    
    func testFailsWhenNoGithubUsers_anyFailsStrategy() {
        let dailymotionUser = DailymotionUsers.DailymotionUser(userName: "dailymotionUser", avatarURL: URL(string: "https://google.com")!)
        let gitHubServiceMock = GitHubUserServiceMock(result: .failure(APIServiceError.noData))
        let dailymotionServiceMock = DailymotionUserServiceMock(result: .success([dailymotionUser]))
        let delegate = ClosureDelegate()
        delegate.didLoadClousure = { (_, users) in
            XCTFail()
        }
        let sut = UsersProvider(gitHubUsersService: gitHubServiceMock, dailymotionUsersService: dailymotionServiceMock)
        sut.delegate = delegate
        
        sut.loadData()
    }
    
    func testFailsWhenNoDailymotionUsers_anyFailsStrategy() {
        let gitHubUser = GitHubUser(userName: "gitHubUser", avatarURL: URL(string: "https://apple.com")!)
        let gitHubServiceMock = GitHubUserServiceMock(result: .success([gitHubUser]))
        let dailymotionServiceMock = DailymotionUserServiceMock(result: .failure(APIServiceError.noData))
        let delegate = ClosureDelegate()
        delegate.didLoadClousure = { (_, users) in
            XCTFail()
        }
        let sut = UsersProvider(gitHubUsersService: gitHubServiceMock, dailymotionUsersService: dailymotionServiceMock)
        sut.delegate = delegate
        
        sut.loadData()
    }
    
    func testReturnsOneSourceUsers_allFailsStrategy() {
        let gitHubUser = GitHubUser(userName: "gitHubUser", avatarURL: URL(string: "https://apple.com")!)
        let gitHubServiceMock = GitHubUserServiceMock(result: .success([gitHubUser]))
        let dailymotionServiceMock = DailymotionUserServiceMock(result: .failure(APIServiceError.noData))
        let delegate = ClosureDelegate()
        delegate.didLoadClousure = { (_, users) in
            XCTAssertEqual(users.count, 1)
            XCTAssertTrue(users.contains(where: { $0.userName == "gitHubUser" }))
        }
        delegate.didFailClousure = { (_) in
            XCTFail()
        }
        let sut = UsersProvider(gitHubUsersService: gitHubServiceMock, dailymotionUsersService: dailymotionServiceMock)
        sut.failureStrategy = .allFails
        sut.delegate = delegate
        
        sut.loadData()
    }
}
