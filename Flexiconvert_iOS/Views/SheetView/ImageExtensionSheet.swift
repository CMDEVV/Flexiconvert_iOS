//
//  ImageExtensionSheet.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI

enum ConvertStatus{
    case idle
    case uploading
    case success
    case failure
}


//struct StoreResultItem: Codable, Identifiable {
//    var id = UUID()
//    let image: String?
//    let format: String?
//    let file_name: String?
// }

struct ImageExtensionSheet: View {
    // String/array
    @State var extensionSelected: String = ""
    @State private var responseText: String = ""

//    let extensions = ["PNG", "JPEG", "GIF", "SVG"]
    let extensions = ["PNG", "JPEG"]
    let rows = [GridItem(.fixed(50))]
    
    // Bool
    @State var goToSuccessView = false
    
    
    @State  var selectedImages: [UIImage] = []
    @State  var imageExtensions: [String] = []
    
    @State var convertStatus : ConvertStatus = .idle
    
    @State var apiResponse : APIResponse?
    @State var storeResultItem = [APIResponse]()
    
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
                                    print("extensionSelecteddd", extensionSelected)
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
                
                StatusOfConvert
            }
            .padding()
            .fullScreenCover(isPresented: $goToSuccessView){
                SuccessView(convertedImages: storeResultItem)
            }
            
//        }
    }
    
    private var convertButton: some View {
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
    
    private var successConvertButton: some View {
        VStack(spacing: 5){
            Button{
                goToSuccessView = true
            } label: {
                VStack(spacing: 5){
                    Text("Convert")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                    
         
                }
            }
            .background(Color(hex: 0x080f90))
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("Success")
                .foregroundStyle(Color.green)
        }
       
    }
    
    private var failedConvertButton: some View {
        VStack(spacing: 5){
            Button{
                convertImages()
            } label: {
                VStack{
                    Text("Retry")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                  
                }
            }
            .background(Color(hex: 0x080f90))
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("Failed")
                .foregroundStyle(Color.red)
        }
    }
    
   
    private var StatusOfConvert: some View{
        VStack{
            switch convertStatus{
            case .idle:
                convertButton
            case .uploading:
                HStack{
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .success:
                successConvertButton
                    .onAppear{
                        goToSuccessView = true
                    }
            case .failure:
                failedConvertButton
            }
        }
    }
    
    func getAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = dict["SERVER_KEY"] as? String {
            return apiKey
        }
        return nil
    }
  
    
    func fetchCSRFToken(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(getAPIKey() ?? "")get-csrf-token/") else {
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
            DispatchQueue.main.async {
                self.convertStatus = .uploading
            }
            
            // Make sure the token exists and is not empty.
            guard let token = token, !token.isEmpty else {
                DispatchQueue.main.async {
                    self.responseText = "CSRF token is empty."
                    self.convertStatus = .failure
                }
                return
            }
            
            print("Token_CSRF:", token)
            
            guard let url = URL(string: "\(getAPIKey() ?? "")convert-file/") else {
                DispatchQueue.main.async {
                    self.responseText = "Invalid URL."
                }
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token, forHTTPHeaderField: "X-CSRFToken")
            
            var imagesPayload: [[String: Any]] = []

            for index in selectedImages.indices {
                let originalExt = imageExtensions[index].lowercased()
                let targetExt = extensionSelected.lowercased()
                
                // Skip if the image is already in the desired format
//                guard originalExt != targetExt else {
//                    print("Skipping image \(index) — already in target format \(targetExt)")
//                    continue
//                }

                // Build conversion type string: e.g., "jpeg_to_png"
                // If conversion are the it doesnt work
                let conversionType = "\(originalExt)_to_\(targetExt)"
                print("Image \(index) conversion: \(conversionType)")

                // Convert image data based on the TARGET format
                let imageData: Data?
                switch targetExt {
                case "png":
                    imageData = selectedImages[index].pngData()
                case "jpeg", "jpg":
                    imageData = selectedImages[index].jpegData(compressionQuality: 1.0)
                default:
                    print("Unsupported target format: \(targetExt)")
                    continue
                }

                guard let data = imageData else {
                    print("Failed to generate image data for image \(index)")
                    continue
                }

                let base64String = data.base64EncodedString()

                imagesPayload.append([
                    "conversion_type": conversionType,
                    "image": base64String,
                    "quality": 90
                ])
            }


            
            let parameters: [String: Any] = ["images": imagesPayload]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                DispatchQueue.main.async {
                    self.responseText = "Error encoding parameters: \(error.localizedDescription)"
                }
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.responseText = "Request error: \(error.localizedDescription)"
                        self.convertStatus = .failure
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        self.responseText = "Invalid response."
                        self.convertStatus = .failure
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.responseText = "No data received."
                        self.convertStatus = .failure
                    }
                    return
                }
                
                // Debug: print the raw response string.
//                if let rawString = String(data: data, encoding: .utf8) {
//                    print("Raw response:", rawString)
//                }
                
                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(APIResponse.self, from: data)
                    DispatchQueue.main.async {
                        if responseData.results.isEmpty {
                            self.responseText = "No results found."
                            self.convertStatus = .failure
                        } else {
                            print("✅ Success")
                            self.convertStatus = .success
                            // Store the response in your shared model.
                            self.storeResultItem.append(responseData)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error decoding response: \(error.localizedDescription)")
                        self.responseText = "Error decoding response: \(error.localizedDescription)"
                        self.convertStatus = .failure
                    }
                }
            }.resume()
        }
    }

}

#Preview {
    ImageExtensionSheet()
}
