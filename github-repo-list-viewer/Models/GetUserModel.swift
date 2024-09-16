//
//  GetUserModel.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation

struct GetUserRequestModel: Codable {
    let username: String
}

struct GetUserResponseModel: Codable {
    let username: String
    let name: String?
    let company: String?
    let location: String?
    let bio: String?
    let publicRepoCount: Int?
    let followerCount: Int?
    let followingCount: Int?
    
    init(username: String, name: String? = nil, company: String? = nil, location: String? = nil, bio: String? = nil, publicRepoCount: Int?, followerCount: Int?, followingCount: Int?) {
        self.username = username
        self.name = name
        self.company = company
        self.location = location
        self.bio = bio
        self.publicRepoCount = publicRepoCount
        self.followerCount = followerCount
        self.followingCount = followingCount
    }
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case name
        case company
        case location
        case bio
        case publicRepoCount = "public_repos"
        case followerCount = "followers"
        case followingCount = "following"
    }
}
