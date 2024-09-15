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
    let avatarURL: String?
    let name: String?
    let company: String?
    let location: String?
    let bio: String?
    let reposURL: String?
    let publicRepos: Int?
    let followers: Int?
    let following: Int?
    
    init(avatarURL: String? = nil, name: String? = nil, company: String? = nil, location: String? = nil, bio: String? = nil, reposURL: String? = nil, publicRepos: Int? = nil, followers: Int? = nil, following: Int? = nil) {
        self.avatarURL = avatarURL
        self.name = name
        self.company = company
        self.location = location
        self.bio = bio
        self.reposURL = reposURL
        self.publicRepos = publicRepos
        self.followers = followers
        self.following = following
    }
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case name
        case company
        case location
        case bio
        case reposURL = "repos_url"
        case publicRepos = "public_repos"
        case followers
        case following
    }
}
