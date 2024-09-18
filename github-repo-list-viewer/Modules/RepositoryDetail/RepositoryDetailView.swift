//
//  RepositoryDetailView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 18.09.2024.
//

import SwiftUI

struct RepositoryDetailView: View {
    
    let item: RepositoryGridItemModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(item.name ?? "")
                    .font(.headline)
                    .foregroundStyle(Colors.textColor)
                
                // Repository Details
                HStack {
                    Text(item.isPrivate ?? false ? "private".localized() : "public".localized())
                        .font(.subheadline)
                        .foregroundStyle(Colors.textColor)
                    
                    Spacer()
                    
                    Text("⭐ \(item.starCount ?? 0)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("👁️ \(item.watchers ?? 0)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Description
                if let description = item.description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                // Language
                if let language = item.language {
                    Text("language".localized(with: language))
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                // Topics
                if let topics = item.topics, !topics.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("topics".localized(with: topics))
                            .font(.headline)
                            .foregroundStyle(Colors.textColor)
                        
                        ForEach(topics, id: \.self) { topic in
                            Text("• \(topic)")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                // Dates
                VStack(alignment: .leading, spacing: 8) {
                    if let createdAt = item.createdAt {
                        Text("created_at".localized(with: formattedDate(createdAt)))
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    if let updatedAt = item.updatedAt {
                        Text("updated_at".localized(with: formattedDate(updatedAt)))
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    RepositoryDetailView(item: PreviewProvider.shared.repositoryGridItems[0])
}
