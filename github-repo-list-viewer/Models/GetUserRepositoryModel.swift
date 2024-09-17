//
//  GetRepositoryModel.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 17.09.2024.
//

import Foundation

struct GetUserRepositoryRequestModel: Codable {
    let username: String
    var maxReposPerPage: Int
    var page: Int
    
    init(username: String, maxReposPerPage: Int = 30, page: Int = 1) {
        self.username = username
        self.maxReposPerPage = maxReposPerPage
        self.page = page
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case maxReposPerPage = "per_page"
        case page
    }
}

struct GetUserRepositoryResponseModel: Codable {
    let id: Int
    let name: String?
    let isPrivate: Bool?
    let description: String?
    let createdAt: String?
    let updatedAt: String?
    let starCount: Int?
    let language: String?
    let topics: [String]?
    let watchers: Int?
    
    init(id: Int, name: String? = nil, isPrivate: Bool?, description: String? = nil, createdAt: String? = nil, updatedAt: String? = nil, starCount: Int?, language: String? = nil, topics: [String]? = nil, watchers: Int?) {
        self.id = id
        self.name = name
        self.isPrivate = isPrivate
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.starCount = starCount
        self.language = language
        self.topics = topics
        self.watchers = watchers
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isPrivate = "private"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case starCount = "stargazers_count"
        case language
        case topics
        case watchers
    }
}
