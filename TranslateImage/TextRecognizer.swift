//
//  TextRecognizer.swift
//  TranslateImage
//
//  Created by Abir Pal on 20/03/2026.
//

import Vision
import UIKit

struct TextBlock {
    let text: String
    let boundingBox: CGRect
}

func performTextRecognition(in image: UIImage, completion: @escaping (String, [TextBlock]) -> Void) {
    guard let cgImage = image.cgImage else {
        completion("", [])
        return
    }
    
    let request = VNRecognizeTextRequest { (request, error) in
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            completion("", [])
            return
        }
        
        let blocks = observations.compactMap { observation -> TextBlock? in
            guard let candidate = observation.topCandidates(1).first else { return nil }
            return TextBlock(text: candidate.string, boundingBox: observation.boundingBox)
        }
        
        let fullText = blocks.map { $0.text }.joined(separator: "\n")
        completion(fullText, blocks)
    }
    
    request.recognitionLevel = .accurate
    let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
    try? handler.perform([request])
}
