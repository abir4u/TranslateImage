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
    @State private var showTransformationCover = false
    @State private var textBlocks: [TextBlock] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Main Canvas
                ZStack {
                    Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            .padding()
                    } else {
                        ContentUnavailableView("No Image Selected",
                                             systemImage: "photo.on.rectangle.angled",
                                             description: Text("Scan or import a photo to extract text."))
                    }
                }
                
                // MARK: - Bottom Action Bar
                VStack(spacing: 20) {
                    if !recognizedText.isEmpty {
                        HStack(spacing: 15) {
                            ActionButton(title: "Copy Text", icon: "doc.on.doc") {
                                UIPasteboard.general.string = recognizedText
                            }
                            
                            ActionButton(title: "Translate", icon: "translate") {
                                showTranslationCover = true
                            }
                            
                            ActionButton(title: "Transform", icon: "wand.and.stars") {
                                showTransformationCover = true
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Button {
                        showSourceSelection = true
                    } label: {
                        Label(image == nil ? "Select Image" : "Change Image", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                .padding()
                .background(.ultraThinMaterial) // Gives that professional translucent look
            }
            .navigationTitle("OptoLingo")
            .navigationBarTitleDisplayMode(.inline)
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
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $image, sourceType: sourceType) { img in
                performTextRecognition(in: img) { text, blocks in
                    self.recognizedText = text
                    self.textBlocks = blocks
                }
            }
        }
        .fullScreenCover(isPresented: $showTranslationCover) {
            TranslationView(textToTranslate: recognizedText)
                }
        .fullScreenCover(isPresented: $showTransformationCover) {
            if let image = image {
                TransformView(originalImage: image, textBlocks: textBlocks)
            }
        }
    }
   }

   // MARK: - Subviews
   struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption).bold()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    ContentView()
}
