//
//  Flexiconvert_iOSApp.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI
import MijickPopups

@main
struct Flexiconvert_iOSApp: App {
    let migrator = Migrator()
    
    var body: some Scene {
        WindowGroup {
                TabBar()
                .registerPopups(id: .shared) { config in config
                        .vertical { $0
                            .enableDragGesture(true)
                            .tapOutsideToDismissPopup(true)
                            .cornerRadius(32)
                        }
                        .center { $0
                            .tapOutsideToDismissPopup(false)
                            .backgroundColor(.white)
                        }
                }
            
//            HomeView()
//                .preferredColorScheme(.light)
        }
    }
}
