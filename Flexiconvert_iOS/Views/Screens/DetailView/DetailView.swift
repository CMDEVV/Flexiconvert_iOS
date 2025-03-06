//
//  DetailView.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI

struct DetailView: View {
    @State var showSheet = false
    @State var showImagePicker = false
    
    @State private var selectedImages: [UIImage] = []
    @State private var imageExtensions: [String] = []
    
    let col = [
        GridItem(),
        GridItem(),
    ]
    var body: some View {
        ZStack{
            // MARK: PlaceHolder
//            EmptyImageView()
            
            VStack{
                if selectedImages.isEmpty{
                    EmptyImageView()
                } else {
                    ScrollView{
                        LazyVGrid(columns: col, spacing: 10){
                            ForEach(Array(selectedImages.indices), id: \.self){ index in
                                VStack{
                                    Image(uiImage: selectedImages[index])
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
                                                    
                                                    Text(imageExtensions[index])
                                                        .foregroundStyle(Color.white)
                                                        .font(.subheadline)
                                                }
                                                
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
                    }.padding(.top, 20)
                }
            }
            .onTapGesture {
                showImagePicker = true
            }
            .sheet(isPresented: $showImagePicker){
                MultiPhotoPicker(selectedImages: $selectedImages, imageExtensions: $imageExtensions)
            }
            
            
            if !selectedImages.isEmpty{
                VStack(alignment:.trailing) {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showSheet = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.2.squarepath")
                                    .foregroundStyle(Color.white)
                                    .frame(width: 35, height: 35)
                            }
                            .padding()
                            .background(Color(hex: 0x080f90))
                            .mask(Circle())
                        }
                    }
                    .padding()
                }
                .padding(.bottom, 30)
                
            }
            
            
//            Button{
//                showSheet = true
//            } label: {
//                Text("Button")
//            }
            
        }
        .navigationTitle("Image Details")
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showSheet){
            ImageExtensionSheet(selectedImages: selectedImages, imageExtensions: imageExtensions)
                .presentationDetents([.height(240)])
        }
//        .toolbarVisibility(.hidden, for: .tabBar)
        
    }
}

#Preview {
    DetailView()
}
