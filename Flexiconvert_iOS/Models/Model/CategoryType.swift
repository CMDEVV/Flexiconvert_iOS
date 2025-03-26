//
//  CategoryType.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 3/25/25.
//

import Foundation

struct CategoryType: Identifiable{
    var id = UUID()
    let orginal: String
    let target: String
    let name: String
    
    static let CategoryTypeList = [
        CategoryType(orginal: "JPEG", target: "PNG", name: "jpeg_to_png"),
        CategoryType(orginal: "PNG", target: "JPEG", name: "png_to_jpeg"),
    ]
}
