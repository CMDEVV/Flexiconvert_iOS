//
//  TabBar.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/27/25.
//
import SwiftUI
struct TabBar: View {
    var body: some View {
        TabView {
                HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
            RecentFilesView()
                .tabItem {
                    Label("Files", systemImage: "folder")
                       
                }
                
//                ThirdTabView()
//                .tabItem {
//                    Label("Settings", systemImage: "gearshape")
//                }
            }
    }
}
