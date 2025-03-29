//
//  DetailView.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var showAlert = false
    @State var showSheet = false
    @State var showSpecificSheet = false
    @State var showImagePicker = false
    @State var selectImages = Bool()
    
    @State private var selectedImages: [UIImage] = []
    @State private var imageExtensions: [String] = []
    @State private var selectedIndices: Set<Int> = []

    
    let col = [
        GridItem(),
        GridItem(),
    ]
    
    @State var categoryTypeSelected: CategoryType?

    private func deleteSelectedImages() {
        let sortedIndices = selectedIndices.sorted(by: >)
        for index in sortedIndices {
            selectedImages.remove(at: index)
            imageExtensions.remove(at: index)
        }
        selectedIndices.removeAll()
    }
    
    var deleteImage: some View {
        Button{
            deleteSelectedImages()
            
        } label: {
            Image(systemName: "trash")
                .imageScale(.large)
                .foregroundStyle(Color.white)
                .frame(width: 115, height: 77)
        }
        .background(Color(hex: 0x080f90))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    var body: some View {
        ZStack{
            // MARK: PlaceHolder
//            EmptyImageView()
            
            VStack{
                if selectedImages.isEmpty{
                    EmptyImageView()
                        .onTapGesture {
                            showImagePicker = true
                        }
                } else {
                    if categoryTypeSelected != nil{
                        HStack{
                            Spacer()
                            
                            Button{
                                selectImages.toggle()
                                
                            } label: {
                                if selectImages{
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
                    }
                    
                    ScrollView{
                        LazyVGrid(columns: col, spacing: 10){
                            ForEach(Array(selectedImages.indices), id: \.self){ index in
                                VStack{
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 175, height: 201)
//                                        .frame(maxWidth: .infinity)
                                        .frame(width: UIDevice.isIPad ? 380 : 175)
                                        .frame(height: UIDevice.isIPad ? 400 : 201)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay{
                                            if categoryTypeSelected != nil{
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(categoryTypeSelected?.orginal.lowercased() == imageExtensions[index]  ? Color.clear : Color.red, lineWidth: 4)
                                                
                                            }
                                        }
//                                        .overlay(
//                                            if categoryTypeSelected != nil{
//                                                RoundedRectangle(cornerRadius: 10)
//                                                    .stroke(categoryTypeSelected?.orginal.lowercased() == imageExtensions[index]  ? Color.clear : Color.red, lineWidth: 4)
//                                                
//                                            }
//                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedIndices.contains(index) ? Color(hex: 0x080f90) : Color.clear, lineWidth: 4)
                                        )
                                        .onTapGesture {
                                            if selectImages {
                                                if selectedIndices.contains(index) {
                                                    selectedIndices.remove(index)
                                                } else {
                                                    selectedIndices.insert(index)
                                                }
                                            } else {
                                                showImagePicker = true
                                            }
                                        }
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
                    }
                    .padding(.top, 20)
//                    .alert("Make sure that all images format are \(categoryTypeSelected?.orginal)", isPresented: $showAlert, actions: Button("OK"){})
                    
                    .safeAreaInset(edge: .bottom){
                        if selectImages{
                            deleteImage
                        }
                    }
                    .onTapGesture {
                        if selectImages == false {
                            showImagePicker = true
                        } else {
                            showImagePicker = false
                        }
                    }
                }
            }
            .alert("Make sure that all images format are \(categoryTypeSelected?.orginal ?? "")", isPresented: $showAlert){
                Button("OK", role: .cancel){}
            }
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("Make sure that all images format are "), message: "", dismissButton: .default(Text("OK")))
//            }
//            .onTapGesture {
//                showImagePicker = true
//            }
            .sheet(isPresented: $showImagePicker){
                MultiPhotoPicker(selectedImages: $selectedImages, imageExtensions: $imageExtensions)
            }
            
            
            if !selectedImages.isEmpty && !selectImages{
                VStack(alignment:.trailing) {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            
                            if categoryTypeSelected != nil{
                                for index in selectedImages.indices {
                                    let originalExt = imageExtensions[index].lowercased()
                                    
                                    if originalExt != categoryTypeSelected?.orginal.lowercased(){
                                        showAlert = true
                                    }
                                }
                                
                            }
                            
                            if showAlert == false {
                                if categoryTypeSelected == nil{
                                    showSheet = true
                                } else{
                                    showSpecificSheet = true
                                }
                            }
                            
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button{self.presentationMode.wrappedValue.dismiss()} label: {Image(systemName: "arrow.left").imageScale(.large).foregroundStyle(Color.black)})
        .toolbar(.hidden, for: .tabBar)
        .onAppear{
            print("categoryTypeSelectedDetail", categoryTypeSelected)
        }
        .sheet(isPresented: $showSpecificSheet){
            SpecificImageExtensionSheet(selectedImages: selectedImages, imageExtensions: imageExtensions, categoryTypeSelected: categoryTypeSelected)
                .presentationDetents([.height(240)])
        }
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
