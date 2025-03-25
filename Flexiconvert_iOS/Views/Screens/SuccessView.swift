//
//  SuccessView.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/27/25.
//

import SwiftUI
import Photos
import RealmSwift

struct APIResponse: Codable{
//    var id = UUID()
    var results: [ResultItem]
}

struct ResultItem: Codable, Hashable {
    var image: String
    var format: String
    var file_name: String
}

struct SuccessView: View {
    @Environment(\.dismiss) var dismiss
    let realm = try! Realm()
    
    
    let col = [
        GridItem(),
        GridItem(),
    ]
    
    @State var goToHome = false
    @State var goToCarousel = false
    @State var convertedImages = [APIResponse]()
    
    // State for images to share
    @State private var imagesToShare: [UIImage] = []
    @State private var isSharing = false
    @State private var downloadStatus: String? = nil


    func base64ToImage(_ base64: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    func formatDate(date: Date) -> String {
          let formatter = DateFormatter()
          formatter.dateFormat = "MM/dd/yy h a" // Format: 03/18/24 10 AM
          formatter.amSymbol = "am"
          formatter.pmSymbol = "pm"
          return formatter.string(from: date)
      }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .foregroundStyle(Color.black)
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: col) {
                        ForEach(convertedImages, id: \.results) { result in
                            ForEach(result.results, id: \.file_name) { data in
                                if let uiImage = base64ToImage(data.image) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 175, height: 201)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(alignment: .bottomLeading) {
                                            VStack(alignment: .leading, spacing: 8) {
                                                HStack {
                                                    Image(systemName: "photo")
                                                        .foregroundStyle(Color(hex: 0x080f90))
                                                    
                                                    Text("\(data.format)")
                                                        .foregroundStyle(Color.white)
                                                        .font(.subheadline)
                                                }
                                            }
                                            .padding(5)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .frame(height: 54)
                                            .background(Color.gray.opacity(0.6))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        .onTapGesture {
                                            // Allow users to select images for sharing
                                            if !imagesToShare.contains(uiImage) {
                                                imagesToShare.append(uiImage)
                                            }
                                        }
                                } else {
                                    Text("Invalid Image")
                                }
                            }
                        }
                    }
                }
                .padding(.top, 15)
                
                
                // Show download status
                if let status = downloadStatus {
                    Text(status)
                        .foregroundColor(.green)
                        .padding()
                }
                
                HStack(spacing: 10) {
                    ViewImage
                    ShareImage
                    DownloadImage
                }
            }
            .padding()
            .padding(.top, 30)
            .onAppear{
                let date = Date()
                for data in convertedImages{
                    for image in data.results{
                        try! realm.write{
                            
                            let recentFilesList = RecentFilesRealmModel()
                            recentFilesList.format = image.format
                            recentFilesList.file_name = image.file_name
                            if let imageData = Data(base64Encoded: image.image){
                                recentFilesList.image = imageData
                            }
                            recentFilesList.date = formatDate(date: date)
                            
                            realm.add(recentFilesList, update: .all)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $goToHome) {
                HomeView()
            }
            .sheet(isPresented: $isSharing) {
                if !imagesToShare.isEmpty {
                    ShareSheet(activityItems: imagesToShare)
                }
            }
            .fullScreenCover(isPresented: $goToCarousel){
                CarouselView(convertedImages: convertedImages)
            }
        }
    }
    
    private var ViewImage: some View {
        Button {
            // View Image Action
            goToCarousel = true
        } label: {
            Image(systemName: "eye")
                .imageScale(.large)
                .foregroundStyle(Color.black)
                .frame(width: 115, height: 77)
        }
        .background(Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private var ShareImage: some View {
        Button {
//            imagesToShare.removeAll() // Clear previous selection
            
            for result in convertedImages {
                for data in result.results {
                    if let uiImage = base64ToImage(data.image) {
                
                        imagesToShare.append(uiImage)
                    }
                }
            }
            
            isSharing = true

        } label: {
            Image(systemName: "arrow.turn.up.right")
                .imageScale(.large)
                .foregroundStyle(Color.black)
                .frame(width: 115, height: 77)
        }
        .background(Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    
    private var DownloadImage: some View {
           Button {
               requestPhotoLibraryPermission { granted in
                   if granted {
                       saveImagesToPhotos()
                   } else {
                       downloadStatus = "Permission Denied"
                   }
               }
           } label: {
               Image(systemName: "square.and.arrow.down")
                   .imageScale(.large)
                   .foregroundStyle(Color.black)
                   .frame(width: 115, height: 77)
           }
           .background(Color.gray.opacity(0.3))
           .clipShape(RoundedRectangle(cornerRadius: 15))
       }
       
       /// Request Photo Library Permission
       func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
           let status = PHPhotoLibrary.authorizationStatus()
           switch status {
           case .authorized:
               completion(true)
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization { newStatus in
                   DispatchQueue.main.async {
                       completion(newStatus == .authorized)
                   }
               }
           default:
               completion(false)
           }
       }
       
       /// Save images to Photos app
       func saveImagesToPhotos() {
           var savedCount = 0
           for result in convertedImages {
               for data in result.results {
                   if let uiImage = base64ToImage(data.image) {
                       UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                       savedCount += 1
                   }
               }
           }
           
           if savedCount > 0 {
               downloadStatus = "Saved \(savedCount) images!"
           } else {
               downloadStatus = "No images to save."
           }
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 5){
               self.downloadStatus = nil 
           }
       }
}

// 📌 **The Proper UIActivityViewController Wrapper (Fixes Blank Screen)**
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
