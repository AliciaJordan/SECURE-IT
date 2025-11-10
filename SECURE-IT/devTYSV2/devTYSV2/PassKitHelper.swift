//
//  PassKitHelper.swift
//  SECURE-IT - Helper para PassKit
//
//  Maneja la creación y adición de passes al Apple Wallet

import Foundation
import PassKit
import UIKit

class PassKitHelper {
    static let shared = PassKitHelper()
    
    private init() {}
    
    /// Verifica si el dispositivo puede agregar passes al Wallet
    func canAddPasses() -> Bool {
        return PKAddPassesViewController.canAddPasses()
    }
    
    /// Crea un PKPass básico para un ticket
    func createPass(for ticket: Ticket) -> PKPass? {
        // Crear el diccionario del pass.json
        let passDictionary: [String: Any] = [
            "formatVersion": 1,
            "passTypeIdentifier": "pass.com.secureit.fifa2026",
            "serialNumber": ticket.id.uuidString,
            "teamIdentifier": "TEAM123456",
            "organizationName": "SECURE-IT FIFA 2026",
            "description": "Boleto oficial para \(ticket.eventName)",
            "logoText": "SECURE-IT",
            "foregroundColor": "rgb(32, 80, 114)",
            "backgroundColor": "rgb(207, 244, 210)",
            "labelColor": "rgb(50, 157, 156)",
            "eventTicket": [
                "primaryFields": [
                    [
                        "key": "event",
                        "label": "Evento",
                        "value": ticket.eventName
                    ]
                ],
                "secondaryFields": [
                    [
                        "key": "date",
                        "label": "Fecha",
                        "value": ticket.date
                    ],
                    [
                        "key": "seat",
                        "label": "Asiento",
                        "value": ticket.seat
                    ]
                ],
                "auxiliaryFields": [
                    [
                        "key": "price",
                        "label": "Precio",
                        "value": String(format: "$%.2f", ticket.price)
                    ]
                ],
                "barcode": [
                    "message": ticket.id.uuidString,
                    "format": "PKBarcodeFormatQR",
                    "messageEncoding": "iso-8859-1"
                ],
                "barcodes": [
                    [
                        "message": ticket.id.uuidString,
                        "format": "PKBarcodeFormatQR",
                        "messageEncoding": "iso-8859-1"
                    ]
                ]
            ]
        ]
        
        // Convertir a JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: passDictionary, options: .prettyPrinted) else {
            print("❌ Error al crear JSON del pass")
            return nil
        }
        
        // Crear el PKPass
        do {
            let pass = try PKPass(data: jsonData)
            return pass
        } catch {
            print("❌ Error al crear PKPass: \(error.localizedDescription)")
            // Para desarrollo/demo, intentamos crear un pass básico sin certificado
            // Nota: En producción necesitarías certificados válidos de Apple Developer
            return createBasicPass(for: ticket)
        }
    }
    
    /// Crea un pass básico sin certificado (para desarrollo/demo)
    private func createBasicPass(for ticket: Ticket) -> PKPass? {
        // Intentar crear un pass mínimo
        let passDictionary: [String: Any] = [
            "formatVersion": 1,
            "passTypeIdentifier": "pass.com.secureit.fifa2026",
            "serialNumber": ticket.id.uuidString,
            "organizationName": "SECURE-IT FIFA 2026",
            "description": ticket.eventName,
            "eventTicket": [
                "primaryFields": [
                    [
                        "key": "event",
                        "label": "Evento",
                        "value": ticket.eventName
                    ]
                ],
                "barcode": [
                    "message": ticket.id.uuidString,
                    "format": "PKBarcodeFormatQR",
                    "messageEncoding": "iso-8859-1"
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: passDictionary, options: .prettyPrinted) else {
            return nil
        }
        
        return try? PKPass(data: jsonData)
    }
    
    /// Muestra el diálogo para agregar el pass al Wallet
    func addPassToWallet(_ pass: PKPass, from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let addPassViewController = PKAddPassesViewController(pass: pass)
        
        guard let addPassVC = addPassViewController else {
            completion(false)
            return
        }
        
        // Presentar el view controller
        viewController.present(addPassVC, animated: true) {
            completion(true)
        }
    }
}

