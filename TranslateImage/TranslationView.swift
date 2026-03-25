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
    @State private var configuration: TranslationSession.Configuration?
    
    @State private var sourceLanguage = "en"
    @State private var targetLanguage = "es"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    Section("Settings") {
                        Picker("From", selection: $sourceLanguage) {
                            // Implement from text field
                        }
                        Picker("To", selection: $targetLanguage) {
                            // Implement to text field
                        }
                    }
                    
                    Section("Original Text") {
                        TextEditor(text: $textToTranslate)
                            .frame(minHeight: 100)
                    }
                    
                    Section("Translation") {
                        // Translation section
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
                .padding()
            }
            .navigationTitle("Translate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    func triggerTranslation() {
        // Implement translation here
    }
}
