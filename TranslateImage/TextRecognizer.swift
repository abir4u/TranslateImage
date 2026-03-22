//
//  TextRecognizer.swift
//  TranslateImage
//
//  Created by Abir Pal on 20/03/2026.
//

import Vision
import UIKit

func performTextRecognition(in image: UIImage, completion: @escaping (String) -> Void) {
    guard let cgImage = image.cgImage else {
        completion("")
        return
    }
    
    let request = VNRecognizeTextRequest { (request, error) in
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            completion("")
            return
        }
        
        let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
        completion(recognizedText)
    }
    
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true
    
    let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
    try? handler.perform([request])
}
