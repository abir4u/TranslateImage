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
    
    let languages = [
        "en": "English", "es": "Spanish", "fr": "French",
        "de": "German", "it": "Italian", "zh": "Chinese", "ja": "Japanese"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    Section("Settings") {
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
                    
                    Section("Original Text") {
                        TextEditor(text: $textToTranslate)
                            .frame(minHeight: 100)
                    }
                    
                    Section("Translation") {
                        if isTranslating {
                            ProgressView("Translating...")
                                .frame(maxWidth: .infinity)
                        } else {
                            Text(translatedText.isEmpty ? "Tap translate to begin" : translatedText)
                                .foregroundColor(translatedText.isEmpty ? .secondary : .primary)
                        }
                    }
                }
                
                Button(action: triggerTranslation) {
                    Text("Translate Now")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(textToTranslate.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(textToTranslate.isEmpty || isTranslating)
                .padding()
            }
            .navigationTitle("Translate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .translationTask(configuration) { session in
                do {
                    let response = try await session.translate(textToTranslate)
                    self.translatedText = response.targetText
                } catch {
                    self.translatedText = "Error: \(error.localizedDescription)"
                }
                self.isTranslating = false
                self.configuration = nil
            }
        }
    }

    func triggerTranslation() {
        isTranslating = true
        configuration = TranslationSession.Configuration(
            source: Locale.Language(identifier: sourceLanguage),
            target: Locale.Language(identifier: targetLanguage)
        )
    }
}
