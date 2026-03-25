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
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceSelection = false
    @State private var showTranslationCover = false

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
                    showSourceSelection = true
                }
                
                Button("Copy Text") {
                    UIPasteboard.general.string = recognizedText
                }
                .disabled(recognizedText.isEmpty)
                
                Button("Translate") {
                    showTranslationCover = true
                }
                .disabled(recognizedText.isEmpty)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showTranslationCover) {
                    // Translation functionality
                }
        .confirmationDialog("Select Source", isPresented: $showSourceSelection) {
                    Button("Camera") {
                        self.sourceType = .camera
                        self.showPicker = true
                    }
                    Button("Photo Gallery") {
                        self.sourceType = .photoLibrary
                        self.showPicker = true
                    }
                    Button("Cancel", role: .cancel) { }
                }
        .sheet(isPresented: $showPicker) {
                    ImagePicker(image: $image, sourceType: sourceType) { img in
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
