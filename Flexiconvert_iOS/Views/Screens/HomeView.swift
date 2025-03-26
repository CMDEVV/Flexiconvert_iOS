//
//  Home.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//


import SwiftUI
import RealmSwift



struct HomeView: View {
    
    let realm = try! Realm()
    // Bool
    @State var goToDetailView = false
    
    let rows = [
        GridItem(.fixed(50))
    ]
    
    
    func base64ToImage(_ base64: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    // Realm Variables
    @ObservedResults(RecentFilesRealmModel.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: false)) var recentFiles
    
    
    // Models
    @State var categoryType : [CategoryType] = CategoryType.CategoryTypeList

    
    var body: some View {
//        let recentFiles = realm.objects(RecentFilesRealmModel.self)
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
                    .padding()
                  
                    
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 250)
            .background(Color(hex: 0x080f90))
            
            // MARK: Recent Files
            
            if !recentFiles.isEmpty{
                VStack{
                    HStack{
                        Text("Recent Files")
                            .font(.headline)
                        
                        Spacer()
                        
//                        Text("show all")
//                            .font(.subheadline)
//                            .foregroundStyle(Color.gray)
                    }
                    
                    
                    ScrollView(.horizontal){
                        LazyHGrid(rows: rows, alignment: .center, spacing: 12){
                            ForEach(Array(recentFiles.prefix(4)), id: \._id){ image in
                              
                                if let uiImage = base64ToImage(image.image.base64EncodedString()) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 226, height: 146)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
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
                            
                            
                        }
                    }
                    .frame(height: 146)
                }
                .padding()
                .padding(.top, 40)
            }
            
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
                        
                        ForEach(categoryType, id: \.id){ result in
                            NavigationLink(destination: DetailView(categoryTypeSelected: result), label: {
                                HStack(spacing: 80){
                                    
                                    Text(result.orginal)
                                        .font(.headline)
                                        .foregroundStyle(Color.black)
                                    
                                    Image(systemName: "arrow.forward")
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color.white)
                                        .background(Color(hex: 0x080f90))
                                        .clipShape(Circle())
                                    
                                    Text(result.target)
                                        .font(.headline)
                                        .foregroundStyle(Color.black)
                                    
                                }
                            })
                          
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
            .padding(.top, recentFiles.isEmpty ? 20 : 0)
            .onAppear{
                
            }
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
