//
//  CustomButton.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import SwiftUI

struct CustomButtonModel {
    let title: String
    var icon: String?
    var cornerRadius: CGFloat? = 24
    var foregroundColor: Color
    var backgroundColor: Color
    var action: () -> Void
}

struct CustomButton: View {
    var model: CustomButtonModel
    
    var body: some View {
        Button {
            withAnimation {
                model.action()
            }
        } label: {
            HStack {
                if let icon = model.icon {
                    Image(icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(model.foregroundColor)
                        .padding(4)
                }
                Text(model.title)
                    .foregroundStyle(model.foregroundColor)
            }
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(model.backgroundColor)
            .cornerRadius(model.cornerRadius ?? 0)
            .overlay {
                if model.backgroundColor == .clear {
                    RoundedRectangle(cornerRadius: model.cornerRadius ?? 0)
                        .stroke(lineWidth: 0.25)
                        .foregroundStyle(model.foregroundColor)
                }
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    CustomButton(model: .init(title: "Hello",
                              cornerRadius: 24,
                              foregroundColor: .black,
                              backgroundColor: .clear,
                              action: { }))
}
