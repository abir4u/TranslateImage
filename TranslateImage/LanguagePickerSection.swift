//
//  ChooseLingoView.swift
//  TranslateImage
//
//  Created by Abir Pal on 27/03/2026.
//

import SwiftUI

struct LanguagePickerSection: View {
    @Binding var source: String
    @Binding var target: String

    var body: some View {
        Section("Settings") {
            Picker("From", selection: $source) {
                ForEach(LanguageSettings.sortedKeys, id: \.self) { key in
                    Text(LanguageSettings.map[key]!).tag(key)
                }
            }
            Picker("To", selection: $target) {
                ForEach(LanguageSettings.sortedKeys, id: \.self) { key in
                    Text(LanguageSettings.map[key]!).tag(key)
                }
            }
        }
    }
}
