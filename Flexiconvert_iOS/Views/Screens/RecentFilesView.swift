//
//  RecentFiles.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI
import RealmSwift

struct RecentFilesView: View {
    let realm = try! Realm()
    
    @ObservedResults(RecentFilesRealmModel.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: false)) var recentFiles

    
    @State var selectAllImages = false
    
    let col = [
        GridItem(),
        GridItem()
    ]
    
    func base64ToImage(_ base64: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    var body: some View {
        ScrollView{
            HStack{
                Text("Recent Files")
                    .font(.headline)
                
                Spacer()
                
                Button{
                    selectAllImages.toggle()
                    
                } label: {
                    if selectAllImages{
                        Image(systemName: "square.grid.3x2.fill")
                            .imageScale(.large)
                    } else{
                        Image(systemName: "square.grid.3x2")
                            .imageScale(.large)
                            .foregroundStyle(Color.black)
                    }
                }
                
            }
            .padding()
            .padding(.top, 20)
//            .frame(width: 175, height: 201)
//            .overlay(alignment: .topTrailing){
//                Button{
//                    
//                } label: {
//                    Image(systemName: "ellipsis")
//                        .imageScale(.large)
//                        .foregroundStyle(Color.black)
//                }
//                .padding()
//            }
            LazyVGrid(columns: col, spacing: 10){
                ForEach(Array(recentFiles), id: \._id){ image in
                    if let uiImage = base64ToImage(image.image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 175, height: 201)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(alignment: .topTrailing){
                                
                                Circle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 30, height: 30)
                                
                                Menu{
                                    // MARK: Download
                                    Button{
                                        
                                    } label: {
                                        HStack{
                                            Image(systemName: "square.and.arrow.down")
                                                .imageScale(.large)
                                                .foregroundStyle(Color.black)
                                            
                                            Text("Download")
                                            
                                        }
                                    }
                                    
                                    // MARK: Share
                                    Button{
                                        
                                    } label: {
                                        HStack{
                                            Image(systemName: "arrow.turn.up.right")
                                                .imageScale(.large)
                                                .foregroundStyle(Color.black)
                                            
                                            Text("Share")
                                        }
                                    }
                                    
                                    // MARK: View
                                    
                                    Button{
                                        
                                    } label: {
                                        HStack{
                                            Image(systemName: "eye")
                                                .imageScale(.large)
                                                .foregroundStyle(Color.black)
                                            
                                            Text("View")
                                        }
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .imageScale(.large)
                                        .foregroundStyle(Color.black)
                                }
                                .frame(width: 30, height: 30)
                                
                               
//                                .padding()
                            }
                            .overlay(alignment: .bottomLeading) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "photo")
                                            .foregroundStyle(Color(hex: 0x080f90))
                                        
                                        Text("\(image.format)")
                                            .foregroundStyle(Color.white)
                                            .font(.subheadline)
                                    }
                                    Text("Added \(image.date)")
                                        .foregroundStyle(Color.white)
                                        .font(.subheadline)
                                }
                                .padding(5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 54)
                                .background(Color.gray.opacity(0.6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                           
                            }
                         
                    } else {
                        Text("Invalid Image")
                    }
                }
                
                Image("bk_img")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 175, height: 201)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(alignment: .topTrailing){
                        
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 30, height: 30)
                        
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
            }
            
          
            
        }
        .safeAreaInset(edge: .bottom){
            if selectAllImages{
                HStack(spacing: 10) {
                    deleteImage
                }
            }
        }
        .toolbar(selectAllImages ? .hidden : .visible, for: .tabBar)
    }
    
    var deleteImage: some View {
        Button{
            
        } label: {
            Image(systemName: "trash")
                .imageScale(.large)
                .foregroundStyle(Color.white)
                .frame(width: 115, height: 77)
        }
        .background(Color(hex: 0x080f90))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    RecentFilesView()
}
