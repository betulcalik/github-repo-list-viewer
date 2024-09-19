//
//  SearchUserViewModelTests.swift
//  github-repo-list-viewerTests
//
//  Created by Betül Çalık on 19.09.2024.
//

import XCTest
import Combine
@testable import github_repo_list_viewer
import CoreData

class SearchUserViewModelTests: XCTestCase {
    var viewModel: SearchUserViewModel!
    var mockGithubManager: MockGithubManager!
    var mockGithubDataModelManager: MockGithubDataModelManager!
    var mockCoreDataManager: MockCoreDataManager!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        mockGithubManager = MockGithubManager()
        mockCoreDataManager = MockCoreDataManager()
        mockGithubDataModelManager = MockGithubDataModelManager(coreDataManager: mockCoreDataManager)
        viewModel = SearchUserViewModel(
            githubManager: mockGithubManager,
            githubDataModelManager: mockGithubDataModelManager
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockGithubManager = nil
        mockGithubDataModelManager = nil
        mockCoreDataManager = nil
        cancellables = []
        super.tearDown()
    }
    
    func testGetUserSuccess() {
        // Arrange
        let responseModel = GetUserResponseModel(
            username: "testuser",
            name: "Test User",
            company: "Test Company",
            location: "Test Location",
            bio: "Test Bio",
            publicRepoCount: 10,
            followerCount: 5,
            followingCount: 3
        )
        
        // Create a mock Core Data User object
        let user = User(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        user.username = "testuser"
        user.name = "Test User"
        user.company = "Test Company"
        user.location = "Test Location"
        user.bio = "Test Bio"
        user.publicRepoCount = 10
        user.followerCount = 5
        user.followingCount = 3
        
        mockGithubManager.getUserResult = .success(responseModel)
        mockGithubDataModelManager.saveUserResult = .success(user)

        // Act
        viewModel.getUser(username: "testuser")

        // Assert
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertNil(viewModel.getUserError)

        // Simulate async completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.searchedUser, user)
            XCTAssertTrue(self.viewModel.shouldNavigateToDetail)
        }
    }
    
    func testGetUserFailure() {
        let error = NetworkError.clientError(statusCode: 401)
        mockGithubManager.getUserResult = .failure(error)
        
        let expectation = self.expectation(description: "Waiting for error response")
        viewModel.getUser(username: "testuser")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.viewModel.showAlert)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }

    func testSaveUserSuccess() {
        // Arrange
        let responseModel = GetUserResponseModel(
            username: "testuser",
            name: "Test User",
            company: "Test Company",
            location: "Test Location",
            bio: "Test Bio",
            publicRepoCount: 10,
            followerCount: 5,
            followingCount: 3
        )
        
        // Create a mock Core Data User object
        let user = User(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        user.username = "testuser"
        user.name = "Test User"
        user.company = "Test Company"
        user.location = "Test Location"
        user.bio = "Test Bio"
        user.publicRepoCount = 10
        user.followerCount = 5
        user.followingCount = 3
        
        mockGithubManager.getUserResult = .success(responseModel)
        mockGithubDataModelManager.saveUserResult = .success(user)

        // Act
        viewModel.getUser(username: "testuser")

        // Assert
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertNil(viewModel.getUserError)

        // Simulate async completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.searchedUser, user)
            XCTAssertTrue(self.viewModel.shouldNavigateToDetail)
        }
    }

    func testSaveUserFailure() {
        // Arrange
        let responseModel = GetUserResponseModel(
            username: "testuser",
            name: "Test User",
            company: "Test Company",
            location: "Test Location",
            bio: "Test Bio",
            publicRepoCount: 10,
            followerCount: 5,
            followingCount: 3
        )
        
        let saveError = NSError(domain: "", code: 0, userInfo: nil)
        mockGithubManager.getUserResult = .success(responseModel)
        mockGithubDataModelManager.saveUserResult = .failure(saveError)

        // Act
        viewModel.getUser(username: "testuser")

        // Assert
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertNil(viewModel.searchedUser)
        XCTAssertFalse(viewModel.shouldNavigateToDetail)

        // Simulate async completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.getUserError as NSError?, saveError)
        }
    }

}
