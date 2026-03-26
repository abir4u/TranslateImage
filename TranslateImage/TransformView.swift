//
//  TransformView.swift
//  TranslateImage
//
//  Created by Abir Pal on 26/03/2026.
//

import SwiftUI
import Translation

struct TransformView: View {
    @Environment(\.dismiss) var dismiss
    var originalImage: UIImage
    var textBlocks: [TextBlock]
    
    @State private var transformedImage: UIImage?
    @State private var isProcessing = false
    @State private var sourceLanguage = "en"
    @State private var targetLanguage = "es"
    
    @State private var configuration: TranslationSession.Configuration?
    
    let languages = [
        "en": "English", "es": "Spanish", "fr": "French",
        "de": "German", "it": "Italian", "zh": "Chinese", "ja": "Japanese"
    ]

    var body: some View {
        NavigationStack {
            VStack {
                if let transformedImage = transformedImage {
                    Image(uiImage: transformedImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Form {
                        Section("Languages") {
                            Picker("From", selection: $sourceLanguage) {
                                ForEach(languages.keys.sorted(), id: \.self) { key in
                                    Text(languages[key]!).tag(key)
                                }
                            }
                            Picker("To", selection: $targetLanguage) {
                                ForEach(languages.keys.sorted(), id: \.self) { key in
                                    Text(languages[key]!).tag(key)
                                }
                            }
                        }
                    }
                }

                Button(action: startTransformation) {
                    if isProcessing {
                        ProgressView()
                    } else {
                        Text(transformedImage == nil ? "Transform Image" : "Save Image")
                            .bold()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isProcessing)
            }
            .navigationTitle("Image Transform")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } }
            }
            .translationTask(configuration) { session in
                await processImage(with: session)
            }
        }
    }

    func startTransformation() {
        isProcessing = true
        configuration = TranslationSession.Configuration(
            source: Locale.Language(identifier: sourceLanguage),
            target: Locale.Language(identifier: targetLanguage)
        )
    }

    func processImage(with session: TranslationSession) async {
        isProcessing = true
        
        var translatedBlocks: [(text: String, rect: CGRect)] = []
        let imgWidth = originalImage.size.width
        let imgHeight = originalImage.size.height
        
        for block in textBlocks {
            do {
                let response = try await session.translate(block.text)
                
                let rect = CGRect(
                    x: block.boundingBox.origin.x * imgWidth,
                    y: (1 - block.boundingBox.origin.y - block.boundingBox.height) * imgHeight,
                    width: block.boundingBox.width * imgWidth,
                    height: block.boundingBox.height * imgHeight
                )
                translatedBlocks.append((text: response.targetText, rect: rect))
            } catch {
                print("Translation failed for block: \(block.text)")
            }
        }
        
        let renderer = UIGraphicsImageRenderer(size: originalImage.size)
        let newImage = renderer.image { context in
            originalImage.draw(at: .zero)
            
            for block in translatedBlocks {
                UIColor.white.setFill()
                context.fill(block.rect)
                
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: block.rect.height * 0.8),
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: style
                ]
                block.text.draw(in: block.rect, withAttributes: attributes)
            }
        }
        
        await MainActor.run {
            self.transformedImage = newImage
            self.isProcessing = false
            self.configuration = nil
        }
    }

}
