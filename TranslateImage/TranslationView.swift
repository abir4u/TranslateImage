//
//  TranslationView.swift
//  TranslateImage
//
//  Created by Abir Pal on 26/03/2026.
//

import SwiftUI
import Translation

struct TranslationView: View {
    @Environment(\.dismiss) var dismiss
    @State var textToTranslate: String
    @State private var translatedText = ""
    @State private var isTranslating = false
    @State private var configuration: TranslationSession.Configuration?
    @State private var sourceLanguage = "en"
    @State private var targetLanguage = "es"

    var body: some View {
        NavigationStack {
            Form {
                LanguagePickerSection(source: $sourceLanguage, target: $targetLanguage)
                
                Section("Original Text") {
                    TextEditor(text: $textToTranslate).frame(minHeight: 100)
                }
                
                Section("Translation") {
                    if isTranslating { ProgressView() }
                    else { Text(translatedText.isEmpty ? "..." : translatedText) }
                }
            }
            .navigationTitle("Translate")
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } } }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button("Translate Now") {
                        configuration = .init(source: .init(identifier: sourceLanguage),
                                              target: .init(identifier: targetLanguage))
                    }
                    .buttonStyle(.borderedProminent).padding()
                    Button("Copy Text") {
                        UIPasteboard.general.string = translatedText
                    }
                    .disabled(translatedText.isEmpty)
                    .buttonStyle(.borderedProminent).padding()
                }
            }
            .translationTask(configuration) { session in
                isTranslating = true
                if let response = try? await session.translate(textToTranslate) {
                    translatedText = response.targetText
                }
                isTranslating = false
            }
        }
    }
}
