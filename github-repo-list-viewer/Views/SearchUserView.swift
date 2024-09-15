//
//  SearchUserView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import SwiftUI

struct SearchUserView: View {
    
    @EnvironmentObject var viewModel: UserViewModel
    @State private var username: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Image("githubIcon")
            
            Text("search_github_repositories".localized())
                .font(.title2)
                .foregroundStyle(Colors.textColor)
                .multilineTextAlignment(.center)
                .padding([.horizontal, .bottom])
            
            VStack(spacing: 20) {
                usernameTextField
                searchButton
            }
            
            Spacer()
        }
        .background(Colors.backgroundColor)
    }
}

extension SearchUserView {
    
    private var usernameTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading)
            
            TextField("username".localized(), text: $username)
                .frame(height: 48)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .background(.thinMaterial)
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var searchButton: some View {
        CustomButton(model: .init(title: "search".localized(),
                                  foregroundColor: Colors.textColor,
                                  backgroundColor: .clear,
                                  action: {
            viewModel.getUser(username: username)
        }))
    }
}

#Preview {
    SearchUserView()
        .environmentObject(PreviewProvider.shared.userViewModel)
}
