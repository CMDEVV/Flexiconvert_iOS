//
//  ImageExtensionSheet.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI

struct ImageExtensionSheet: View {
    let extensions = ["PNG", "JPEG", "GIF", "SVG"]
    let rows = [GridItem(.fixed(50))]
    var body: some View {
        VStack(alignment: .leading){
            Text("Extension")
                .font(.headline)
                .padding(.top, 30)
            
            ScrollView(.horizontal){
                LazyHGrid(rows: rows){
                    ForEach(extensions, id: \.self){ item in
                        VStack{
                            Text(item)
                        }
                        .frame(width: 60, height: 40)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
            }
            
            Spacer()
            
            Button{
                
            } label: {
                Text("Convert")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
            }
            .background(Color(hex: 0x080f90))
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
    }
}

#Preview {
    ImageExtensionSheet()
}
