//
//  Extension.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI
import UIKit


extension Color{
    init(hex: Int, opacity: Double = 1){
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
