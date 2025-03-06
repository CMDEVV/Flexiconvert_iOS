//
//  ImageExtensionSheet.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI

struct ImageExtensionSheet: View {
    // String/array
    @State var extensionSelected: String = ""
    @State private var responseText: String = ""

    let extensions = ["PNG", "JPEG", "GIF", "SVG"]
    let rows = [GridItem(.fixed(50))]
    
    // Bool
    @State var goToSuccessView = false
    
    
    @State  var selectedImages: [UIImage] = []
    @State  var imageExtensions: [String] = []
    
    var body: some View {
//        NavigationStack{
            VStack(alignment: .leading){
                Text("Extension")
                    .font(.headline)
                    .padding(.top, 30)
                
                ScrollView(.horizontal){
                    LazyHGrid(rows: rows){
                        ForEach(extensions, id: \.self){ item in
                            VStack{
                                Button{
                                    extensionSelected = item
                                } label: {
                                    Text(item)
                                }
                            }
                            .frame(width: 60, height: 40)
                            .background(extensionSelected == item ? Color(hex: 0x080f90) : Color.white)
                            .foregroundStyle(extensionSelected == item ? Color.white : Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 1)
                        }
                    }
                }
                
                Spacer()
                
                Button{
//                    goToSuccessView = true
                    convertImages()
                } label: {
                    Text("Convert")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                }
                .background(Color(hex: 0x080f90))
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            .fullScreenCover(isPresented: $goToSuccessView){
                SuccessView()
            }
            
//        }
    }
    
    
    
    func fetchCSRFToken(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "") else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching token: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response String: \(responseString)")
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let csrfToken = json["CSRF cookie set!"] as? String else {
                print("Failed to parse CSRF token from JSON")
                completion(nil)
                return
            }
            completion(csrfToken)
        }.resume()
    }

    
    func convertImages() {
        fetchCSRFToken { token in
            // Make sure to use the token variable provided in the closure.
//            guard let token = csrfToken else {
//                print("Failed to fetch CSRF token")
//                return
//            }
            print("Token_CSRF", token ?? "")
            guard let url = URL(string: "") else {
                self.responseText = "Invalid URL."
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token, forHTTPHeaderField: "X-CSRFToken")
            
            var imagesPayload: [[String: Any]] = []
            for index in Array(selectedImages.indices) {
                
                // Decide conversion type based on file extension.
                // For example, if it's PNG, convert to JPEG; if JPEG, convert to PNG.
                var conversionType: String
                if imageExtensions[index].lowercased() == "png" {
                    conversionType = "png_to_jpeg"
                } else if imageExtensions[index].lowercased()  == "jpg" || imageExtensions[index].lowercased() == "jpeg" {
                    conversionType = "jpeg_to_png"
                } else {
                    // Fallback: default to PNG conversion.
                    conversionType = "png_to_jpeg"
                }
                
                // Convert the UIImage accordingly.
                let imageData: Data?
                if conversionType == "png_to_jpeg" {
                    // Convert PNG to JPEG data.
                    imageData = selectedImages[index].jpegData(compressionQuality: 1.0)
                } else {
                    // Convert JPEG to PNG data.
                    imageData = selectedImages[index].pngData()
                }
                print("imageDataFound", imageData as Any)
                guard let data = imageData else { continue }
                print("DataFOUND", data)
                let base64String = data.base64EncodedString()
                imagesPayload.append([
                    "conversion_type": conversionType,
                    "image": base64String,
                    "quality": 90,
                    "width": "300",
                    "height": "300"
                ])
            }
//            print("ImagesPayload", imagesPayload)
            let parameters: [String: Any] = ["images": imagesPayload]
//            print("Parameterss", parameters)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                self.responseText = "Error encoding parameters: \(error.localizedDescription)"
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.responseText = "Request error: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        self.responseText = "Invalid response."
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.responseText = "No data received."
                    }
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if (200...299).contains(httpResponse.statusCode) {
                                // Check if there's a success flag in JSON (if your backend returns one)
                                if let success = jsonResponse["success"] as? Bool, success {
                                    print("✅Success: \(jsonResponse)")
                                } else {
                                  print( "✅Success status not found, but HTTP status indicates success")
                                    print(jsonResponse)
//                                    Response: ["results": <__NSSingleObjectArrayI 0x300c5ced0>(
//                                    {
//                                        "file_name" = "converted_image_1.png";
//                                        format = PNG;
//                                        image =
                                }
                            } else {
                                // Handle non-success status codes
                                print("Error \(httpResponse.statusCode): \(jsonResponse)")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                        print("Unexpected response format.")
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error parsing response: \(error.localizedDescription)")
                    }
                }
            }.resume()

        }
      
       }
}

#Preview {
    ImageExtensionSheet()
}
