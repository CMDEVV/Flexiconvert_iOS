//
//  CarouselView.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 3/18/25.
//

import SwiftUI
import RealmSwift


struct CarouselView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var convertedImages = [APIResponse]()

//    var imageNames: [String]

    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    
    @State private var selectedImageIndex: Int = 0
    
    func base64ToImage(_ base64: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    var body: some View {
        ZStack {
            Color.secondary
                .ignoresSafeArea()

            TabView(selection: $selectedImageIndex) {
                ForEach(convertedImages, id: \.results) { result in
                    ForEach(result.results, id: \.file_name) { data in
                        if let uiImage = base64ToImage(data.image) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 400)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Text("Invalid Image")
                        }
                    }
                }
            }
            .frame(height: 500)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()

            
            HStack {
                ForEach(0..<convertedImages.count, id: \.self) { index in
                    Capsule()
                        .fill(Color.white.opacity(selectedImageIndex == index ? 1 : 0.33))
                        .frame(width: 35, height: 8)
                        .onTapGesture {
                            selectedImageIndex = index
                        }
                }
                .offset(y: 250)
            }
        }
        .overlay(alignment: .topTrailing){
            Button{
                dismiss()
            } label: {
                Image(systemName: "x.circle").imageScale(.large)
                    .foregroundStyle(Color.black)
            }
            .padding()
        }
        .onReceive(timer) { _ in
            withAnimation(.default) {
                selectedImageIndex = (selectedImageIndex + 1) % convertedImages.count
            }
        }
    }
}




struct CarouselViewRecentFiles: View {
    
    @Environment(\.dismiss) var dismiss
//    @State var convertedImages = [APIResponse]()
//    @ObservedResults(RecentFilesRealmModel.self) var recentFilesImages
    
//    @State var recentFilesImages = [RecentFilesRealmModel]()
    var recentFilesImages: RecentFilesRealmModel

    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    
    @State private var selectedImageIndex: Int = 0
    
    func base64ToImage(_ base64: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    var body: some View {
        ZStack {
            Color.secondary
                .ignoresSafeArea()

            TabView(selection: $selectedImageIndex) {
//                ForEach(recentFilesImages, id: \._id) { result in
                    if let uiImage = base64ToImage(recentFilesImages.image.base64EncodedString()) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Text("Invalid Image")
                    }
//                }
            }
            .frame(height: 500)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            
//            HStack {
//                ForEach(0..<recentFilesImages.count, id: \.self) { index in
//                    Capsule()
//                        .fill(Color.white.opacity(selectedImageIndex == index ? 1 : 0.33))
//                        .frame(width: 35, height: 8)
//                        .onTapGesture {
//                            selectedImageIndex = index
//                        }
//                }
//                .offset(y: 250)
//            }
        }
        .onAppear{
            print("recentFilesImagesCarousel", recentFilesImages)
        }
        .overlay(alignment: .topTrailing){
            Button{
                dismiss()
            } label: {
                Image(systemName: "x.circle").imageScale(.large)
                    .foregroundStyle(Color.black)
            }
            .padding()
        }
        .onReceive(timer) { _ in
//            withAnimation(.default) {
//                selectedImageIndex = (selectedImageIndex + 1) % recentFilesImages.count
//            }
        }
    }
}



struct VisualEffectBlur<Content: View>: View {
    var blurStyle: UIBlurEffect.Style
    var vibrancyStyle: UIVibrancyEffectStyle?
    var content: Content
    
    init(blurStyle: UIBlurEffect.Style = .systemMaterial, vibrancyStyle: UIVibrancyEffectStyle? = nil, @ViewBuilder content: () -> Content) {
        self.blurStyle = blurStyle
        self.vibrancyStyle = vibrancyStyle
        self.content = content()
    }
    
    var body: some View {
        Representable(blurStyle: blurStyle, vibrancyStyle: vibrancyStyle, content: ZStack { content })
            .accessibility(hidden: Content.self == EmptyView.self)
    }
}

extension VisualEffectBlur {
    struct Representable<Content: View>: UIViewRepresentable {
        var blurStyle: UIBlurEffect.Style
        var vibrancyStyle: UIVibrancyEffectStyle?
        var content: Content
        
        func makeUIView(context: Context) -> UIVisualEffectView {
            context.coordinator.blurView
        }
        
        func updateUIView(_ view: UIVisualEffectView, context: Context) {
            context.coordinator.update(content: content, blurStyle: blurStyle, vibrancyStyle: vibrancyStyle)
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(content: content)
        }
    }
}

extension VisualEffectBlur.Representable {
    class Coordinator {
        let blurView = UIVisualEffectView()
        let vibrancyView = UIVisualEffectView()
        let hostingController: UIHostingController<Content>
        
        init(content: Content) {
            hostingController = UIHostingController(rootView: content)
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.view.backgroundColor = nil
            blurView.contentView.addSubview(vibrancyView)
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            vibrancyView.contentView.addSubview(hostingController.view)
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        func update(content: Content, blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle?) {
            hostingController.rootView = content
            let blurEffect = UIBlurEffect(style: blurStyle)
            blurView.effect = blurEffect
            if let vibrancyStyle = vibrancyStyle {
                vibrancyView.effect = UIVibrancyEffect(blurEffect: blurEffect, style: vibrancyStyle)
            } else {
                vibrancyView.effect = nil
            }
            hostingController.view.setNeedsDisplay()
        }
    }
}

extension VisualEffectBlur where Content == EmptyView {
    init(blurStyle: UIBlurEffect.Style = .systemMaterial) {
        self.init( blurStyle: blurStyle, vibrancyStyle: nil) {
            EmptyView()
        }
    }
}

struct VisualEffectBlur_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.red, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial, vibrancyStyle: .fill) {
                Text("Hello World!")
                    .frame(width: 200, height: 100)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
