//
//  RepositoryGridItemModel.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 18.09.2024.
//

import Foundation

struct RepositoryGridItemModel: Identifiable {
    let id = UUID()
    
    let name: String?
    let isPrivate: Bool?
    let description: String?
    let createdAt: Date?
    let updatedAt: Date?
    let starCount: Int?
    let language: String?
    let topics: [String]?
    let watchers: Int?
}
