//
//  Home.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//


import SwiftUI

// MARK: TODO
// - Need to create Model for cards
// - limit the number of recent files (max:3) (Later on once database is added)
// - Navigation to Detail View
// - Navigation to Recent Files View

struct HomeView: View {
    
    // Bool
    @State var goToDetailView = false
    
    let rows = [
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        NavigationStack{
            // MARK: Top Home
            VStack{
                VStack{
                    Spacer()
                    HStack{
                        Text("Home")
                            .font(.largeTitle)
                            .foregroundStyle(Color.white)
                    }
                    //.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    // .background(Color.red)
                  
                    
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 250)
            .background(Color(hex: 0x080f90))
            
            // MARK: Recent Files
            
            VStack{
                HStack{
                    Text("Recent Files")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("show all")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                
                ScrollView(.horizontal){
                    LazyHGrid(rows: rows, alignment: .center, spacing: 12){
                        // Files/images go here
                        Image("bk_img")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 226, height: 146)
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
                .frame(height: 146)
            }
            .padding()
            .padding(.top, 40)
          
            
            // MARK: Category
            
            VStack(alignment: .leading){
                Text("Category")
                    .font(.headline)
                
                // Add SrollView
                ScrollView{
                    VStack(spacing: 12){
                        // Card
                        HStack(spacing: 80){
                            Text("CUSTOM")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 104)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 1)
                        .onTapGesture {
                            goToDetailView = true
                        }
                        
                        HStack(spacing: 80){
                            Text("PNG")
                                .font(.headline)
                            
                            Image(systemName: "arrow.forward")
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.white)
                                .background(Color(hex: 0x080f90))
                                .clipShape(Circle())
                                
                            
                            Text("JPEG")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 104)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 1)
                        
                        HStack(spacing: 80){
                            Text("PNG")
                                .font(.headline)
                            
                            Image(systemName: "arrow.forward")
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.white)
                                .background(Color(hex: 0x080f90))
                                .clipShape(Circle())
                                
                            
                            Text("JPEG")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 104)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 1)
                    }
                    .padding(1)
                }
               
                
                
            }
            .padding()
            .navigationDestination(isPresented: $goToDetailView){
                DetailView()
            }
//            .padding(.top, 30)
            
            Spacer()
        }
        
    }
}

#Preview {
    HomeView()
}
