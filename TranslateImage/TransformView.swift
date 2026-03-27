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
    let originalImage: UIImage
    let textBlocks: [TextBlock]
    
    @State private var transformedImage: UIImage?
    @State private var isProcessing = false
    @State private var sourceLanguage = "en"
    @State private var targetLanguage = "es"
    @State private var configuration: TranslationSession.Configuration?

    var body: some View {
        NavigationStack {
            VStack {
                if let transformedImage {
                    Image(uiImage: transformedImage).resizable().scaledToFit().padding()
                } else {
                    Form {
                        LanguagePickerSection(source: $sourceLanguage, target: $targetLanguage)
                    }
                }
            }
            .navigationTitle("Image Transform")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(transformedImage == nil ? "Transform" : "Done") {
                    if transformedImage == nil {
                        configuration = .init(source: .init(identifier: sourceLanguage),
                                             target: .init(identifier: targetLanguage))
                    } else { dismiss() }
                }
                .buttonStyle(.borderedProminent).padding()
            }
            .translationTask(configuration) { session in
                await processImage(with: session)
            }
        }
    }

    func processImage(with session: TranslationSession) async {
        isProcessing = true
        var translatedData: [(text: String, rect: CGRect)] = []
        let size = originalImage.size

        for block in textBlocks {
            if let response = try? await session.translate(block.text) {
                let rect = CGRect(
                    x: block.boundingBox.origin.x * size.width,
                    y: (1 - block.boundingBox.origin.y - block.boundingBox.height) * size.height,
                    width: block.boundingBox.width * size.width,
                    height: block.boundingBox.height * size.height
                )
                translatedData.append((response.targetText, rect))
            }
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        let result = renderer.image { context in
            originalImage.draw(at: .zero)
            for item in translatedData {
                UIColor.white.setFill() // Placeholder for background matching
                context.fill(item.rect)
                item.text.draw(in: item.rect, withAttributes: [.font: UIFont.systemFont(ofSize: item.rect.height * 0.8)])
            }
        }

        await MainActor.run {
            self.transformedImage = result
            self.isProcessing = false
        }
    }
}
