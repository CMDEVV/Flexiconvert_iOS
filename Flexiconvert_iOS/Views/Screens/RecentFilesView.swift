//
//  RecentFiles.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI

struct RecentFilesView: View {
    
    let col = [
        GridItem(),
        GridItem()
    ]
    var body: some View {
        ScrollView{
            HStack{
                Text("Recent Files")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "square.grid.3x2")
            }
            .padding()
            .padding(.top, 20)
            
            LazyVGrid(columns: col, spacing: 10){
                Image("bk_img")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 175, height: 201)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(alignment: .topTrailing){
                        Button{
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                                .foregroundStyle(Color.black)
                        }
                        .padding()
                    }
                    .overlay(alignment: .bottomLeading){
                        VStack(alignment: .leading, spacing: 8){
                            HStack{
                                // Add Icon
                                Image(systemName: "photo")
                                    .foregroundStyle(Color(hex: 0x080f90))
                                
                                Text("Image.jpg")
                                    .foregroundStyle(Color.white)
                                    .font(.subheadline)
                            }
                            
                            Text("Added 02/26/25 11am")
                                .font(.subheadline)
                                .foregroundStyle(Color.white)
                        }
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 54)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                
                Image("bk_img")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 175, height: 201)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(alignment: .bottomLeading){
                        VStack(alignment: .leading, spacing: 8){
                            HStack{
                                // Add Icon
                                Image(systemName: "photo")
                                    .foregroundStyle(Color(hex: 0x080f90))
                                
                                Text("Image.jpg")
                                    .foregroundStyle(Color.white)
                                    .font(.subheadline)
                            }
                            
                            Text("Added 02/26/25 11am")
                                .font(.subheadline)
                                .foregroundStyle(Color.white)
                        }
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 54)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
            
            
        }
    }
}

#Preview {
    RecentFilesView()
}
