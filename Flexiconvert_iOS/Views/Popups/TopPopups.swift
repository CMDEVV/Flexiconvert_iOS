//
//  TopPopups.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 3/27/25.
//


import SwiftUI
import MijickPopups

struct TopPopupSavedImages: TopPopup {
    @Binding var downloadStatus: String
    var body: some View {
        VStack(spacing: 0) {
            Text(downloadStatus)
                .foregroundStyle(Color.green)
        }
        .padding(.vertical, 20)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                Task{
                  await self.dismissLastPopup()
                    
                }
            }
            
        }
        
        
    }
    func configurePopup(config: TopPopupConfig) -> TopPopupConfig {
        config
            .cornerRadius(20)
            .popupHorizontalPadding(12)
            .popupTopPadding(40)
    }
}


struct TopPopupConvertedFiles: TopPopup {
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "checkmark")
                .imageScale(.large)
                .foregroundStyle(Color.green)
            
            Text("Images Converted Successfully")
                .foregroundStyle(Color.green)
        }
        .zIndex(1)
        .padding(.vertical, 20)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                Task{
                  await self.dismissLastPopup()
                    
                }
            }
            
        }
        
        
    }
    func configurePopup(config: TopPopupConfig) -> TopPopupConfig {
        config
            .cornerRadius(20)
            .popupHorizontalPadding(12)
            .popupTopPadding(40)
    }
}


struct TopPopupView: View {
    let message: String
    let duration: TimeInterval
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            if isShowing {
                Text(message)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
            }
            Spacer()
        }
        .animation(.spring(), value: isShowing)
    }
}



#Preview{
    TopPopupView(message: "Images Converted", duration: 20, isShowing: .constant(true))
}


