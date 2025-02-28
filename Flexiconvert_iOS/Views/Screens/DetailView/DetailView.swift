//
//  DetailView.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 2/26/25.
//

import SwiftUI

struct DetailView: View {
    @State var showSheet = false
    var body: some View {
        VStack{
            // MARK: PlaceHolder
//            EmptyImageView()
            
            Button{
                showSheet = true
            } label: {
                Text("Button")
                    
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showSheet){
            ImageExtensionSheet()
                .presentationDetents([.height(240)])
        }
//        .toolbarVisibility(.hidden, for: .tabBar)
        
    }
}

#Preview {
    DetailView()
}
