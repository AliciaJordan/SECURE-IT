//
//  LoginView.swift
//  SECURE-IT - Vista de Login
//
//  Pantalla para usuarios que ya tienen cuenta

import SwiftUI

struct LoginView: View {
    @StateObject private var userManager = UserManager.shared
    @State private var clientID = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showMainView = false
    @State private var showRegistration = false
    @State private var isLoading = false
    
    // Paleta SECURE-IT
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    var body: some View {
        if showMainView {
            MainVerificationView()
        } else if showRegistration {
            UserRegistrationView()
        } else {
            ZStack {
                // Fondo con gradiente
                LinearGradient(
                    gradient: Gradient(colors: [
                        primaryTeal.opacity(0.08),
                        primaryPale.opacity(0.15),
                        Color.white
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 80)
                        
                        // Logo y branding
                        VStack(spacing: 20) {
                            // Logo hexagonal
                            ZStack {
                                HexagonShape()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [primaryTeal, primaryGreen]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .shadow(color: primaryTeal.opacity(0.4), radius: 20, x: 0, y: 10)
                                
                                HexagonShape()
                                    .stroke(Color.white.opacity(0.4), lineWidth: 3)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: "shield.checkered.fill")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 8) {
                                Text("SECURE-IT")
                                    .font(.system(size: 36, weight: .black))
                                    .foregroundColor(primaryDark)
                                    .tracking(1)
                                
                                Text("FIFA 2026")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(primaryTeal)
                                    .tracking(2)
                            }
                        }
                        .padding(.bottom, 50)
                        
                        // Card de login
                        VStack(spacing: 24) {
                            VStack(spacing: 12) {
                                Text("Bienvenido de nuevo")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Text("Ingresa tu ID de cliente para continuar")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.bottom, 8)
                            
                            // Campo de ID
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 10) {
                                    Image(systemName: "person.text.rectangle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(primaryTeal)
                                    
                                    Text("ID de Cliente")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(primaryDark)
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "key.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(primaryTeal.opacity(0.6))
                                    
                                    TextField("FIFA2026-XXXXXXXX", text: $clientID)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(primaryDark)
                                        .autocapitalization(.allCharacters)
                                        .disableAutocorrection(true)
                                        .onChange(of: clientID) { newValue in
                                            // Auto-formatear el ID
                                            clientID = newValue.uppercased()
                                        }
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(showError ? Color.red : primaryTeal.opacity(0.3), lineWidth: 1.5)
                                )
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                            }
                            
                            // Mensaje de error
                            if showError {
                                HStack(spacing: 10) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.red)
                                    
                                    Text(errorMessage)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            // Botón de login
                            Button(action: {
                                handleLogin()
                            }) {
                                HStack(spacing: 12) {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        Text("Verificando...")
                                            .font(.system(size: 17, weight: .bold))
                                    } else {
                                        Image(systemName: "arrow.right.circle.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                        Text("Iniciar Sesión")
                                            .font(.system(size: 17, weight: .bold))
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryTeal, primaryGreen]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(29)
                                .shadow(color: primaryGreen.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                            .disabled(clientID.isEmpty || isLoading)
                            .opacity(clientID.isEmpty ? 0.6 : 1.0)
                            
                            // Divider
                            HStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                                
                                Text("O")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 12)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                            }
                            .padding(.vertical, 8)
                            
                            // Botón de registro
                            Button(action: {
                                withAnimation {
                                    showRegistration = true
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "person.badge.plus.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                    Text("Crear Nueva Cuenta")
                                        .font(.system(size: 17, weight: .bold))
                                }
                                .foregroundColor(primaryTeal)
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 29)
                                        .stroke(primaryTeal, lineWidth: 2)
                                )
                                .cornerRadius(29)
                            }
                        }
                        .padding(28)
                        .background(primaryPale.opacity(0.2))
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
                        .padding(.horizontal, 24)
                        
                        Spacer()
                            .frame(height: 40)
                        
                        // Info de ayuda
                        VStack(spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(primaryTeal)
                                
                                Text("¿No recuerdas tu ID?")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(primaryDark)
                            }
                            
                            Text("Tu ID de cliente fue generado al registrarte. Revisa tu correo o crea una nueva cuenta.")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 24)
                        
                        Spacer()
                            .frame(height: 50)
                    }
                }
            }
        }
    }
    
    private func handleLogin() {
        // Validar formato
        if !clientID.hasPrefix("FIFA2026-") {
            showError = true
            errorMessage = "ID inválido. Debe comenzar con FIFA2026-"
            return
        }
        
        if clientID.count != 17 { // FIFA2026- (9) + 8 caracteres
            showError = true
            errorMessage = "ID inválido. Formato: FIFA2026-XXXXXXXX"
            return
        }
        
        isLoading = true
        showError = false
        
        // Simular verificación con delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            
            if userManager.login(with: clientID) {
                // Login exitoso
                withAnimation {
                    showMainView = true
                }
            } else {
                // ID no encontrado
                showError = true
                errorMessage = "ID no encontrado. Verifica tu ID o crea una cuenta nueva."
            }
        }
    }
}

#Preview {
    LoginView()
}
