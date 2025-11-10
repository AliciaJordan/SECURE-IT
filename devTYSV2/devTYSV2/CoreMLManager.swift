//
//  CoreMLManager.swift
//  devTYSV2
//
//  Created by RIcardo Bucio on 10/17/25.
//

import CoreML
import UIKit
import Vision

class CoreMLManager: ObservableObject {
    struct PassportCountryResult {
        let isoCode: String
        let displayName: String
    }
    
    private var model: VNCoreMLModel?
    private var passportOriginModel: VNCoreMLModel?
    
    private let iso3CountryMap: [String: String] = [
        "MEX": "México",
        "USA": "Estados Unidos",
        "CAN": "Canadá",
        "BRA": "Brasil",
        "ARG": "Argentina",
        "ESP": "España",
        "FRA": "Francia",
        "DEU": "Alemania",
        "ITA": "Italia",
        "GBR": "Reino Unido",
        "JPN": "Japón",
        "KOR": "Corea del Sur",
        "AUS": "Australia",
        "CHN": "China",
        "COL": "Colombia",
        "PER": "Perú",
        "CHL": "Chile",
        "URY": "Uruguay",
        "PRY": "Paraguay",
        "ECU": "Ecuador",
        "VEN": "Venezuela",
        "CUB": "Cuba",
        "DOM": "República Dominicana",
        "PAN": "Panamá",
        "GTM": "Guatemala",
        "HND": "Honduras",
        "SLV": "El Salvador",
        "NIC": "Nicaragua",
        "CRI": "Costa Rica",
        "BOL": "Bolivia",
        "PRT": "Portugal",
        "NLD": "Países Bajos",
        "BEL": "Bélgica",
        "CHE": "Suiza",
        "SWE": "Suecia",
        "NOR": "Noruega",
        "DNK": "Dinamarca",
        "FIN": "Finlandia",
        "IRL": "Irlanda",
        "ISL": "Islandia",
        "POL": "Polonia",
        "CZE": "República Checa",
        "AUT": "Austria",
        "HUN": "Hungría",
        "GRC": "Grecia",
        "TUR": "Turquía",
        "ISR": "Israel",
        "ZAF": "Sudáfrica",
        "NZL": "Nueva Zelanda",
        "RUS": "Rusia",
        "UKR": "Ucrania",
        "IND": "India"
    ]
    
    init() {
        loadModel()
        loadPassportOriginModel()
    }
    
    private func loadModel() {
        // Try different possible locations and names for the model
        let possibleNames = [
            ("ImageClassifier5", "mlmodel"),
            ("ImageClassifier5", "mlmodelc"),
            ("iageclassifier5", "mlmodel"),
            ("iageclassifier5", "mlmodelc")
        ]
        
        for (name, ext) in possibleNames {
            if let modelURL = Bundle.main.url(forResource: name, withExtension: ext) {
                do {
                    let mlModel = try MLModel(contentsOf: modelURL)
                    model = try VNCoreMLModel(for: mlModel)
                    print("CoreML model loaded successfully: \(name).\(ext)")
                    return
                } catch {
                    print("Error loading CoreML model \(name).\(ext): \(error)")
                }
            }
        }
        
        print("Could not find any CoreML model in bundle")
        // For testing purposes, we'll simulate a working model
        print("Using fallback classification (INE 100%)")
    }
    
    private func loadPassportOriginModel() {
        let modelName = "passMEX"
        let extensions = ["mlmodelc", "mlmodel"]
        
        for ext in extensions {
            if let modelURL = Bundle.main.url(forResource: modelName, withExtension: ext) {
                do {
                    let mlModel: MLModel
                    if ext == "mlmodel" {
                        let compiledURL = try MLModel.compileModel(at: modelURL)
                        mlModel = try MLModel(contentsOf: compiledURL)
                    } else {
                        mlModel = try MLModel(contentsOf: modelURL)
                    }
                    passportOriginModel = try VNCoreMLModel(for: mlModel)
                    print("Loaded passMEX model with extension \(ext)")
                    return
                } catch {
                    print("Error loading passMEX model \(ext): \(error)")
                }
            }
        }
        
        print("Could not load passMEX model from bundle")
    }
    
    func classifyImage(_ image: UIImage, completion: @escaping (String, Double) -> Void) {
        guard let model = model else {
            print("Model not loaded - using fallback")
            // Fallback: return INE with 100% confidence for testing
            DispatchQueue.main.async {
                completion("INE", 1.0)
            }
            return
        }
        
        guard let cgImage = image.cgImage else {
            print("Could not get CGImage from UIImage")
            completion("Error", 0.0)
            return
        }
        
        print("Starting classification...")
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                print("Error performing classification: \(error)")
                completion("Error", 0.0)
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation] else {
                print("No classification results")
                completion("Error", 0.0)
                return
            }
            
            print("Classification results: \(results.count)")
            for result in results {
                print("\(result.identifier): \(result.confidence)")
            }
            
            guard let topResult = results.first else {
                print("No top result")
                completion("Error", 0.0)
                return
            }
            
            let identifier = topResult.identifier
            let confidence = Double(topResult.confidence)
            
            print("Final result: \(identifier) with confidence \(confidence)")
            
            DispatchQueue.main.async {
                completion(identifier, confidence)
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Error performing request: \(error)")
            completion("Error", 0.0)
        }
    }
    
    func detectPassportCountry(from image: UIImage, completion: @escaping (PassportCountryResult?) -> Void) {
        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard error == nil,
                  let observations = request.results as? [VNRecognizedTextObservation],
                  let self = self else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
            guard !recognizedStrings.isEmpty else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let joinedText = recognizedStrings.joined(separator: " ").uppercased()
            
            if let result = self.matchCountry(in: joinedText) {
                DispatchQueue.main.async {
                    completion(result)
                }
                return
            }
            
            let normalizedText = joinedText.folding(options: .diacriticInsensitive, locale: .current)
            if let result = self.matchCountry(in: normalizedText) {
                DispatchQueue.main.async {
                    completion(result)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: image.cgImageOrientation, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Error performing text recognition: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    private func matchCountry(in text: String) -> PassportCountryResult? {
        if let iso3Code = extractIso3Code(from: text) {
            let displayName = iso3CountryMap[iso3Code] ?? iso3Code
            return PassportCountryResult(isoCode: iso3Code, displayName: displayName)
        }
        
        for (iso3, name) in iso3CountryMap {
            if text.contains(name.uppercased()) {
                return PassportCountryResult(isoCode: iso3, displayName: name)
            }
        }
        
        return nil
    }
    
    private func extractIso3Code(from text: String) -> String? {
        if let range = text.range(of: "P<[A-Z]{3}", options: .regularExpression) {
            let codeStart = text.index(range.lowerBound, offsetBy: 2)
            let iso3Code = String(text[codeStart..<text.index(codeStart, offsetBy: 3)])
            return iso3Code
        }
        
        if let match = text.range(of: "\\b[A-Z]{3}\\b", options: [.regularExpression]) {
            let iso3Code = String(text[match])
            if iso3CountryMap.keys.contains(iso3Code) {
                return iso3Code
            }
        }
        
        return nil
    }
    
    func classifyPassportOrigin(_ image: UIImage, completion: @escaping (String, Double) -> Void) {
        guard let passportOriginModel = passportOriginModel else {
            DispatchQueue.main.async {
                completion("unknown", 0.0)
            }
            return
        }
        
        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async {
                completion("error", 0.0)
            }
            return
        }
        
        let request = VNCoreMLRequest(model: passportOriginModel) { request, error in
            if let error = error {
                print("Error classifying passport origin: \(error)")
                DispatchQueue.main.async {
                    completion("error", 0.0)
                }
                return
            }
            
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                DispatchQueue.main.async {
                    completion("unknown", 0.0)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(topResult.identifier.uppercased(), Double(topResult.confidence))
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: image.cgImageOrientation, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Error performing passport origin classification: \(error)")
                DispatchQueue.main.async {
                    completion("error", 0.0)
                }
            }
        }
    }
}

private extension UIImage {
    var cgImageOrientation: CGImagePropertyOrientation {
        switch imageOrientation {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }
}
