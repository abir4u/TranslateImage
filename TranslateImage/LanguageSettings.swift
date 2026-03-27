//
//  LanguageSettings.swift
//  TranslateImage
//
//  Created by Abir Pal on 27/03/2026.
//

import Foundation

struct LanguageSettings {
    static let map = [
        "en": "English", "es": "Spanish", "fr": "French",
        "de": "German", "it": "Italian", "zh": "Chinese", "ja": "Japanese"
    ]
    static var sortedKeys: [String] { map.keys.sorted() }
}
