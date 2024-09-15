//
//  APIKeyManager.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation

final class APIKeyManager {
    
    static let shared = APIKeyManager()
    
    private init() { }
    
    // Retrieves the GitHub API key from the app's Info.plist file.
    // Returns the API key as a string if it exists, otherwise returns nil.
    func getGithubAPIKey() -> String? {
        if let APIKey = Bundle.main.infoDictionary?["GITHUB_API_KEY"] as? String {
            return APIKey
        }
        
        return nil
    }
    
}
