//
//  BannerView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 17.09.2024.
//

import SwiftUI

struct BannerView: View {
    
    var text: String
    
    var body: some View {
        ZStack {
            Text(text)
                .padding()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .background(.accent)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

#Preview {
    BannerView(text: "no_internet_connection".localized())
}
