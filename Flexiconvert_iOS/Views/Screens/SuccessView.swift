//
//  SuccessView.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/27/25.
//

import SwiftUI

struct SuccessView: View {
    @Environment(\.dismiss) var dismiss
    let col = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
    ]
    
    @State var goToHome = false
    
    var body: some View {
        NavigationStack{
            
            VStack{
                HStack{
                    Spacer()
                    Button{
                        // Need to make sure it dismiss back to home view 
                        dismiss()
//                        goToHome = true
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .foregroundStyle(Color.black)
                    }
                }
                ScrollView{
                    LazyVGrid(columns: col){
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
                                    
                                }
                                .padding(5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 54)
                                .background(Color.gray.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                    }
                }
                
                HStack(spacing: 10){
                    ViewImage
                    ShareImage
                    DownloadImage
                }
            }
            .padding()
            .padding(.top, 30)
            .navigationDestination(isPresented: $goToHome){
                HomeView()
            }
        }
            
    }
    
    private var ViewImage: some View {
        Button{
            
        }label: {
            Image(systemName: "eye")
                .imageScale(.large)
                .foregroundStyle(Color.black)
                .frame(width: 115, height: 77)
        }
        .background(Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private var ShareImage: some View {
        Button{
            
        }label: {
            Image(systemName: "arrow.turn.up.right")
                .imageScale(.large)
                .foregroundStyle(Color.black)
                .frame(width: 115, height: 77)
        }
        .background(Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private var DownloadImage: some View {
        Button{
            
        }label: {
            Image(systemName: "square.and.arrow.down")
                .imageScale(.large)
                .foregroundStyle(Color.black)
                .frame(width: 115, height: 77)
        }
        .background(Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    SuccessView()
}
