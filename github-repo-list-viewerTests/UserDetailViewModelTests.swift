//
//  UserDetailViewModelTests.swift
//  github-repo-list-viewerTests
//
//  Created by Betül Çalık on 19.09.2024.
//

import XCTest
import Combine
import CoreData
@testable import github_repo_list_viewer

final class UserDetailViewModelTests: XCTestCase {
    
    var viewModel: UserDetailViewModel!
    var mockGithubManager: MockGithubManager!
    var mockGithubDataModelManager: MockGithubDataModelManager!
    var mockCoreDataManager: MockCoreDataManager!
    var user: User!
    
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockGithubManager = MockGithubManager()
        mockCoreDataManager = MockCoreDataManager()
        mockGithubDataModelManager = MockGithubDataModelManager(coreDataManager: mockCoreDataManager)
        
        // Sample User object for testing
        user = User(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        user.username = "sampleUser"
        
        viewModel = UserDetailViewModel(user: user, githubManager: mockGithubManager, githubDataModelManager: mockGithubDataModelManager)
        
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockGithubManager = nil
        mockGithubDataModelManager = nil
        mockCoreDataManager = nil
        user = nil
        cancellables = nil
        super.tearDown()
    }

    // Test: Sorting Repositories by Star Count
    func testSortRepositoriesByStarCount() {
        // Arrange
        let repo1 = Repository(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        repo1.name = "Repo1"
        repo1.starCount = 5

        let repo2 = Repository(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        repo2.name = "Repo2"
        repo2.starCount = 10

        viewModel.repositories = [repo1, repo2]

        // Act
        viewModel.sortRepositoriesByStarCount()

        // Assert
        XCTAssertEqual(viewModel.repositories.first?.starCount, 10, "Repositories should be sorted by star count")
    }
    
    // Test: Sorting Repositories by Created At
    func testSortRepositoriesByCreatedAt() {
        // Arrange
        let repo1 = Repository(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        repo1.name = "Repo1"
        repo1.createdAt = DateFormatter.iso8601.date(from: "2023-09-18T10:15:30Z")

        let repo2 = Repository(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        repo2.name = "Repo2"
        repo2.createdAt = DateFormatter.iso8601.date(from: "2023-09-19T12:20:45Z")

        viewModel.repositories = [repo2, repo1]

        // Act
        viewModel.sortRepositoriesByCreatedAt()

        // Assert
        XCTAssertEqual(viewModel.repositories.first?.name, "Repo1", "Repositories should be sorted by createdAt, with the oldest first")
    }
    
    // Test: Sorting Repositories by Updated At
    func testSortRepositoriesByUpdatedAt() {
        // Arrange
        let repo1 = Repository(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        repo1.name = "Repo1"
        repo1.updatedAt = DateFormatter.iso8601.date(from: "2023-09-17T09:10:20Z")

        let repo2 = Repository(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        repo2.name = "Repo2"
        repo2.updatedAt = DateFormatter.iso8601.date(from: "2023-09-19T14:35:50Z")

        viewModel.repositories = [repo2, repo1]

        // Act
        viewModel.sortRepositoriesByUpdatedAt()

        // Assert
        XCTAssertEqual(viewModel.repositories.first?.name, "Repo1", "Repositories should be sorted by updatedAt, with the oldest first")
    }
}
