//
//  ContentView.swift
//  TranslateImage
//
//  Created by Abir Pal on 20/03/2026.
//

import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    @State private var image: UIImage?
    @State private var recognizedText = ""
    @State private var showPicker = false
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            ScrollView {
                Text(recognizedText)
                    .padding()
            }
            
            HStack {
                Button("Select Image") {
                    showPicker = true
                }
                
                Button("Copy Text") {
                    UIPasteboard.general.string = recognizedText
                }
                .disabled(recognizedText.isEmpty)
            }
            .padding()
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $image) { img in
                performTextRecognition(in: img) { text in
                    recognizedText = text
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
