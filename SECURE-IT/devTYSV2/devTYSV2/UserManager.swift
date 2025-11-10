//
//  UserManager.swift
//  SECURE-IT - Sistema de Gestión de Usuario
//
//  Maneja persistencia y autenticación de usuarios

import Foundation
import UIKit

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    // Keys para UserDefaults
    private let clientIDKey = "clientID"
    private let usernameKey = "username"
    private let fullNameKey = "fullName"
    private let phoneKey = "phone"
    private let emailKey = "email"
    private let birthYearKey = "birthYear"
    private let nationalityKey = "nationality"
    private let isOnboardingCompletedKey = "isOnboardingCompleted"
    private let isRegisteredKey = "isRegistered"
    
    // Published properties
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    
    // NUEVO: Boleto asociado
    @Published var ticket: Ticket? = Ticket.example
    
    private init() {
        loadUserData()
    }
    
    // MARK: - User Model
    struct User: Codable {
        let clientID: String
        let username: String
        let fullName: String
        let phone: String
        let email: String
        let birthYear: String
        let nationality: String
        let registrationDate: Date
    }
    
    // MARK: - Ticket Model (simple, puedes expandirlo)
    struct Ticket: Identifiable, Codable {
        let id: UUID
        let number: String
        let match: String
        let status: String
        let purchaseDate: Date
        let updates: [TicketUpdate]
        let imageData: Data?
        
        static var example: Ticket {
            Ticket(
                id: UUID(),
                number: "FIFA-TCKT-2026-87654",
                match: "México vs Canadá - 11 Junio 2026",
                status: "Verificado",
                purchaseDate: Date(timeIntervalSinceNow: -86400 * 30),
                updates: [
                    TicketUpdate(date: Date(timeIntervalSinceNow: -86400 * 25), message: "Boleto registrado correctamente."),
                    TicketUpdate(date: Date(timeIntervalSinceNow: -86400 * 8), message: "Verificación IA completada: auténtico."),
                    TicketUpdate(date: Date(timeIntervalSinceNow: -86400 * 2), message: "Listo para el acceso en estadio.")
                ],
                imageData: nil
            )
        }
    }
    
    struct TicketUpdate: Identifiable, Codable {
        let id = UUID()
        let date: Date
        let message: String
    }
    
    // ... (resto del archivo sin cambios)
    // (Mantén todo el resto igual, solo se agregaron las nuevas structs y la propiedad ticket)
    
    // MARK: - Onboarding
    func hasCompletedOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: isOnboardingCompletedKey)
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: isOnboardingCompletedKey)
    }
    
    // MARK: - Registration Status
    func isUserRegistered() -> Bool {
        return UserDefaults.standard.bool(forKey: isRegisteredKey)
    }
    
    // MARK: - Save User
    func saveUser(clientID: String, username: String, fullName: String, phone: String, email: String, birthYear: String, nationality: String) {
        let user = User(
            clientID: clientID,
            username: username,
            fullName: fullName,
            phone: phone,
            email: email,
            birthYear: birthYear,
            nationality: nationality,
            registrationDate: Date()
        )
        
        // Guardar en UserDefaults
        UserDefaults.standard.set(clientID, forKey: clientIDKey)
        UserDefaults.standard.set(username, forKey: usernameKey)
        UserDefaults.standard.set(fullName, forKey: fullNameKey)
        UserDefaults.standard.set(phone, forKey: phoneKey)
        UserDefaults.standard.set(email, forKey: emailKey)
        UserDefaults.standard.set(birthYear, forKey: birthYearKey)
        UserDefaults.standard.set(nationality, forKey: nationalityKey)
        UserDefaults.standard.set(true, forKey: isRegisteredKey)
        
        // Actualizar estado
        currentUser = user
        isLoggedIn = true
    }
    
    // MARK: - Login
    func login(with clientID: String) -> Bool {
        let savedClientID = UserDefaults.standard.string(forKey: clientIDKey)
        
        if let savedClientID = savedClientID, savedClientID == clientID {
            loadUserData()
            return true
        }
        
        return false
    }
    
    // MARK: - Load User Data
    private func loadUserData() {
        guard let clientID = UserDefaults.standard.string(forKey: clientIDKey),
              let username = UserDefaults.standard.string(forKey: usernameKey),
              let fullName = UserDefaults.standard.string(forKey: fullNameKey),
              let phone = UserDefaults.standard.string(forKey: phoneKey),
              let email = UserDefaults.standard.string(forKey: emailKey),
              let birthYear = UserDefaults.standard.string(forKey: birthYearKey),
              let nationality = UserDefaults.standard.string(forKey: nationalityKey) else {
            isLoggedIn = false
            currentUser = nil
            return
        }
        
        currentUser = User(
            clientID: clientID,
            username: username,
            fullName: fullName,
            phone: phone,
            email: email,
            birthYear: birthYear,
            nationality: nationality,
            registrationDate: Date()
        )
        isLoggedIn = true
    }
    
    // MARK: - Logout
    func logout() {
        // No borramos los datos, solo cambiamos el estado
        isLoggedIn = false
    }
    
    // MARK: - Get Client ID
    func getClientID() -> String? {
        return UserDefaults.standard.string(forKey: clientIDKey)
    }
    
    // MARK: - Clear All Data (para testing)
    func clearAllData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        isLoggedIn = false
        currentUser = nil
    }
}

