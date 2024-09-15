//
//  SearchUserView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import SwiftUI

struct SearchUserView: View {
    
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    SearchUserView()
        .environmentObject(PreviewProvider.shared.userViewModel)
}
