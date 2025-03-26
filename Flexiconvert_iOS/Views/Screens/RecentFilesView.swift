//
//  RecentFiles.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI
import RealmSwift
import Photos


struct RecentFilesView: View {
    let realm = try! Realm()
    
    @ObservedResults(RecentFilesRealmModel.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: false)) var recentFiles

    @State var imageSelected: RecentFilesRealmModel?
    @State var selectAllImages = Bool()
    @State var goToCarousel = false
    @State var isSharing = false
    @State private var downloadStatus: String? = nil
    @State private var imagesToShare: [UIImage] = []
//    @State private var selectedImages: Set<Int> = []
    @State private var selectedImages: Set<ObjectId> = []
    @State private var selectedImagesToDelete = [RecentFilesRealmModel]()


    
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
    
    
//    private func toggleSelection(for index: Int, image: RecentFilesRealmModel) {
//    private func toggleSelection(for index: Int) {
//          if selectedImages.contains(index) {
//              selectedImages.remove(index)
////              selectedImagesToDelete.removeAll(where: {$0._id == image._id})
//          } else {
//              selectedImages.insert(index)
////              selectedImagesToDelete.append(image)
////              selectedImagesToDelete.insert(image, at: 0)
//          }
//      }
    
    private func toggleSelection(for image: RecentFilesRealmModel) {
        let id = image._id

        if selectedImages.contains(id) {
            selectedImages.remove(id)
            selectedImagesToDelete.removeAll(where: { $0._id == id })
        } else {
            selectedImages.insert(id)
            selectedImagesToDelete.insert(image, at: 0)
        }
    }
    
    var body: some View {
        VStack{
            
            if recentFiles.isEmpty{
                Image("nofile_icon")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(Color.gray)
                
                Text("No files found")
                    .font(.headline)
                    .padding(.top, 10)
                    .foregroundStyle(Color.gray)
            } else {
                
                HStack{
                    Text("Recent Files")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button{
                        selectAllImages.toggle()
                        
                        
                        if !selectAllImages {
                            selectedImages.removeAll()
                            selectedImagesToDelete.removeAll()
                        }
                        
                        print("Click BUTTONNNN")
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
                
                ScrollView{
                    LazyVGrid(columns: col, spacing: 10){
                        ForEach(Array(recentFiles), id: \._id){ image in
                            if let uiImage = base64ToImage(image.image.base64EncodedString()) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 175, height: 201)
                                    .background(selectAllImages && selectedImages.contains(image._id) ? Color(hex: 0x080f90) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectAllImages && selectedImages.contains(image._id) ? Color(hex: 0x080f90) : Color.clear, lineWidth: 3)
                                    )
                                    .overlay(alignment: .topTrailing){
                                        if !selectAllImages {
                                            Circle()
                                                .fill(Color.gray.opacity(0.4))
                                                .frame(width: 30, height: 30)
                                                .padding(5)
                                            
                                            Menu{
                                                // MARK: Download
                                                Button{
                                                    saveImagesToPhotos(image: image)
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
                                                    
                                                    // if let uiImagess = base64ToImage(image.image.base64EncodedData()){
                                                    imagesToShare.append(uiImage)
                                                    // }
                                                    
                                                    isSharing = true
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
                                                    // DispatchQueue.main.async{
                                                    self.imageSelected = image
                                                    //  }
                                                    print("imageSelected", imageSelected!)
                                                    // if !self.imageSelected.isEmpty{
                                                    self.goToCarousel = true
                                                    // }
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
                                            
                                        }
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
                                    .onTapGesture {
                                        if selectAllImages {
                                            toggleSelection(for: image)
                                        }
                                        
                                    }
                                
                            } else {
                                Text("Invalid Image")
                            }
                        }
                        
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom){
            Group{
                // Show download status
                if let status = downloadStatus {
                    Text(status)
                        .foregroundColor(.green)
                        .padding()
                }
                
                if selectAllImages{
                    HStack(spacing: 10) {
                        deleteImage
                    }
                }
            }
        }
        .toolbar(selectAllImages ? .hidden : .visible, for: .tabBar)
        .sheet(isPresented: $isSharing) {
            if !imagesToShare.isEmpty {
                let imageS = imagesToShare[0]
                
            
                ShareSheet(activityItems: [imageS])
            }
        }
        .fullScreenCover(isPresented: $goToCarousel){
            CarouselViewRecentFiles(recentFilesImages: self.imageSelected ?? RecentFilesRealmModel())
        }
    }
    
   
    
    
    /// Save images to Photos app
    func saveImagesToPhotos(image: RecentFilesRealmModel) {
        var savedCount = 0
        if let uiImage = base64ToImage(image.image.base64EncodedString()) {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            savedCount += 1
        }
    
        if savedCount > 0 {
            downloadStatus = "Saved \(savedCount) images!"
        } else {
            downloadStatus = "No images to save."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            downloadStatus = nil
        }
    }
    
    
    
    var deleteImage: some View {
        Button{
            for frozenObject in selectedImagesToDelete {
                if let thawedObject = frozenObject.thaw(), // thaw the object
                   let realm = thawedObject.realm {
                    try? realm.write {
                        realm.delete(thawedObject)
                    }
                }
            }
            
            // Clear selections and exit selection mode
            selectedImages.removeAll()
            selectedImagesToDelete.removeAll()
            selectAllImages = false

            
//            print("selectedImagesToDelete", selectedImagesToDelete)
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
    RecentFilesView(imageSelected: RecentFilesRealmModel())
}
