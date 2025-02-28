//
//  EmptyImageView.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI

struct EmptyImageView: View {
    var body: some View {
        VStack(spacing: 15){
            Image(systemName: "photo")
                .resizable()
                .frame(width: 140, height: 140)
                .foregroundStyle(Color.gray)
            
            
            Text("click to add image")
                .font(.headline)
                .foregroundStyle(Color.gray)
        }
    }
}

#Preview {
    EmptyImageView()
}
