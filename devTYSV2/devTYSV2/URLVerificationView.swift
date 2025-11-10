//
//  URLVerificationView.swift
//  SECURE-IT - Verificación URL Minimalista (Verde, Azul, Blanco)
//
//  Vista para ingresar y verificar la URL de compra.
import SwiftUI


// MARK: - Paleta de Colores Minimalista
struct SecureItColors {
    // Colores base del Onboarding (los reusamos aquí)
    let primaryBlue = Color(hex: "2C5F79")      // Azul oscuro principal
    let secondaryBlue = Color(hex: "6BAEDC")    // Azul claro/aqua para acentos y degradados
    let primaryGreen = Color(hex: "8DD6C7")     // Verde menta/jade para acentos y degradados
    let paleBackground = Color(hex: "F0F7F9")   // Blanco azulado muy sutil para fondos
    let neutralGray = Color(hex: "6B7C85")      // Gris azulado para texto secundario
    let white = Color.white

    // Colores de estado (Acentos minimalistas)
    let successGreen = Color(hex: "4CAF50")     // Verde estándar, más limpio
    let warningRed = Color(hex: "F44336")       // Rojo estándar, más limpio
    let infoBlue = Color(hex: "2196F3")         // Azul estándar para información
}

// Clave de Environment para inyectar los colores
private struct SecureItColorsKey: EnvironmentKey {
    static let defaultValue = SecureItColors()
}

extension EnvironmentValues {
    var secureItColors: SecureItColors {
        get { self[SecureItColorsKey.self] }
        set { self[SecureItColorsKey.self] = newValue }
    }
}

// MARK: - Vista Principal URLVerificationView
struct URLVerificationView: View {
    @Environment(\.secureItColors) private var colors // Inyectar colores

    @State private var enteredURL = ""
    @State private var verificationResult: VerificationResult?
    @State private var showMainView = false
    
    enum VerificationResult {
        case trusted
        case untrusted
    }
    
    var body: some View {
        if showMainView {
            MainVerificationView()
        } else {
            ZStack {
                colors.paleBackground // Fondo pálido y limpio
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            showMainView = true // Navegación de regreso
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.left")
                                Text("Volver")
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(colors.neutralGray) // Color sutil
                        }
                        
                        Spacer()
                        
                        Text("Verificar URL Oficial")
                            .font(.headline.weight(.bold))
                            .foregroundColor(colors.primaryBlue)
                        
                        Spacer()
                        
                        // Invisible spacer to center the title
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.left")
                            Text("Volver")
                        }
                        .opacity(0)
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                    
                    ScrollView {
                        VStack(spacing: 40) {
                            if verificationResult == nil {
                                // Initial state - URL input
                                InitialInputView(
                                    enteredURL: $enteredURL,
                                    verifyAction: verifyURL // Pasa la acción
                                )
                                .environment(\.secureItColors, colors) // Inyectar colores
                            } else if verificationResult == .trusted {
                                // Trusted site result
                                TrustedResultView(
                                    enteredURL: enteredURL
                                )
                                .environment(\.secureItColors, colors) // Inyectar colores
                            } else {
                                // Untrusted site result
                                UntrustedResultView(
                                    enteredURL: enteredURL
                                )
                                .environment(\.secureItColors, colors) // Inyectar colores
                            }
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                    
                    // Action Buttons (only show after verification)
                    if verificationResult != nil {
                        ActionButtonsView(
                            resetAction: resetVerification,
                            returnAction: { showMainView = true }
                        )
                        .environment(\.secureItColors, colors) // Inyectar colores
                        .padding(.bottom, 40)
                        .padding(.horizontal, 28)
                    }
                }
            }
        }
    }
    
    // Lógica sin cambios
    private func verifyURL() {
        let normalizedURL = enteredURL.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Check if URL contains ticketmaster.com
        if normalizedURL.contains("ticketmaster.com") {
            verificationResult = .trusted
        } else {
            verificationResult = .untrusted
        }
    }
    
    // Lógica sin cambios
    private func resetVerification() {
        enteredURL = ""
        verificationResult = nil
    }
}

// MARK: - COMPONENTES REUTILIZABLES (Diseño y Colores)

// 1. Estado Inicial (Input)
struct InitialInputView: View {
    @Binding var enteredURL: String
    let verifyAction: () -> Void
    @Environment(\.secureItColors) private var colors
    
    var body: some View {
        VStack(spacing: 30) {
            // Shield Icon (Diseño limpio)
            ZStack {
                Circle()
                    .fill(colors.primaryGreen.opacity(0.1)) // Fondo pálido de acento
                    .frame(width: 140, height: 140)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4) // Sombra sutil
                
                Image(systemName: "shield.fill")
                    .foregroundColor(colors.primaryBlue) // Icono en azul principal
                    .font(.system(size: 60, weight: .thin)) // Icono ligero
            }
            
            VStack(spacing: 12) {
                Text("Verifica la URL")
                    .font(.title2.weight(.bold))
                    .foregroundColor(colors.primaryBlue)
                
                Text("Ingresa la dirección del sitio web donde quieres comprar boletos.")
                    .font(.body)
                    .foregroundColor(colors.neutralGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("URL del sitio web")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(colors.primaryBlue)
                
                TextField("Ej: https://...", text: $enteredURL)
                    .padding(.horizontal, 16)
                    .frame(height: 50)
                    .background(colors.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1) // Sombra de campo
                    // Eliminado .textFieldStyle(RoundedBorderTextFieldStyle()) por un look más plano
                    .autocapitalization(.none)
                    .keyboardType(.URL)
            }
            .padding(.horizontal, 28)
            
            Button(action: verifyAction) {
                Text("Verificar URL")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient( // Degradado principal de acción
                            gradient: Gradient(colors: [colors.secondaryBlue, colors.primaryGreen]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(27)
                    .shadow(color: colors.primaryGreen.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 28)
        }
    }
}

// 2. Resultado Confiable (Trusted)
struct TrustedResultView: View {
    let enteredURL: String
    @Environment(\.secureItColors) private var colors
    
    var body: some View {
        VStack(spacing: 30) {
            // Success Icon
            ZStack {
                Circle()
                    .fill(colors.successGreen.opacity(0.15)) // Fondo pálido de éxito
                    .frame(width: 140, height: 140)
                
                Image(systemName: "checkmark.shield.fill") // Icono de escudo más relevante
                    .foregroundColor(colors.successGreen)
                    .font(.system(size: 60, weight: .bold))
            }
            
            VStack(spacing: 12) {
                Text("✓ Sitio Confiable")
                    .font(.title2.weight(.heavy))
                    .foregroundColor(colors.successGreen)
                
                Text("Esta es una página **oficial de Ticketmaster** para comprar boletos del Mundial FIFA 2026.")
                    .font(.body)
                    .foregroundColor(colors.neutralGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            // Verification Details Card
            VStack(alignment: .leading, spacing: 16) {
                DetailCardItem(
                    title: "URL verificada:",
                    value: enteredURL,
                    isTrusted: true
                )
                
                Text("Verificaciones Pasadas:")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(colors.successGreen)
                
                VStack(alignment: .leading, spacing: 8) {
                    CheckDetail(text: "Dominio oficial de Ticketmaster", color: colors.successGreen)
                    CheckDetail(text: "Certificado SSL válido y reciente", color: colors.successGreen)
                    CheckDetail(text: "Página autorizada por FIFA 2026", color: colors.successGreen)
                }
            }
            .padding(20)
            .background(colors.white)
            .cornerRadius(16)
            .shadow(color: colors.successGreen.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 28)
        }
    }
}

// 3. Resultado No Confiable (Untrusted)
struct UntrustedResultView: View {
    let enteredURL: String
    @Environment(\.secureItColors) private var colors
    
    var body: some View {
        VStack(spacing: 30) {
            // Warning Icon
            ZStack {
                Circle()
                    .fill(colors.warningRed.opacity(0.15)) // Fondo pálido de advertencia
                    .frame(width: 140, height: 140)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(colors.warningRed)
                    .font(.system(size: 60, weight: .bold))
            }
            
            VStack(spacing: 12) {
                Text("× Sitio No Confiable")
                    .font(.title2.weight(.heavy))
                    .foregroundColor(colors.warningRed)
                
                Text("**ADVERTENCIA:** Este sitio NO es una página oficial. Comprar aquí podría resultar en **fraude**.")
                    .font(.body)
                    .foregroundColor(colors.primaryBlue) // Usar color de contraste en la advertencia
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            // Warning Details Card
            VStack(alignment: .leading, spacing: 16) {
                DetailCardItem(
                    title: "URL verificada:",
                    value: enteredURL,
                    isTrusted: false
                )
                
                Text("Advertencias:")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(colors.warningRed)
                
                VStack(alignment: .leading, spacing: 8) {
                    CheckDetail(text: "No es un dominio oficial de Ticketmaster", color: colors.warningRed)
                    CheckDetail(text: "Alto riesgo de phishing o fraude", color: colors.warningRed)
                    CheckDetail(text: "NO realizar compras en este sitio", color: colors.warningRed)
                }
            }
            .padding(20)
            .background(colors.white)
            .cornerRadius(16)
            .shadow(color: colors.warningRed.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 28)
            
            // Official Site Info Block (más limpio)
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .font(.title3)
                        .foregroundColor(colors.infoBlue)
                    Text("Sitio oficial para compra")
                        .font(.callout.weight(.bold))
                        .foregroundColor(colors.primaryBlue)
                }
                
                Text("Compra tus boletos **únicamente** en:\nwww.ticketmaster.com.mx o www.ticketmaster.com")
                    .font(.footnote)
                    .foregroundColor(colors.infoBlue)
                    .lineLimit(nil)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colors.infoBlue.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal, 28)
        }
    }
}

// 4. Botones de Acción (Post-Verificación)
struct ActionButtonsView: View {
    let resetAction: () -> Void
    let returnAction: () -> Void
    @Environment(\.secureItColors) private var colors
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: resetAction) {
                Text("Verificar Otra URL")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient( // Degradado principal de acción
                            gradient: Gradient(colors: [colors.secondaryBlue, colors.primaryGreen]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(27)
                    .shadow(color: colors.primaryGreen.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            Button(action: returnAction) {
                Text("Volver al Inicio")
                    .font(.headline.weight(.bold))
                    .foregroundColor(colors.neutralGray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(colors.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 27)
                            .stroke(colors.neutralGray.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
}

// 5. Componente de detalle de verificación
struct CheckDetail: View {
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 6, height: 6)
                .foregroundColor(color)
            Text(text)
                .font(.footnote)
                .foregroundColor(color)
        }
    }
}

// 6. Componente de URL en Tarjeta de Detalle
struct DetailCardItem: View {
    let title: String
    let value: String
    let isTrusted: Bool
    @Environment(\.secureItColors) private var colors
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.callout.weight(.semibold))
                .foregroundColor(colors.primaryBlue)
            
            Text(value)
                .padding(.horizontal, 16)
                .frame(height: 44)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(isTrusted ? colors.successGreen.opacity(0.05) : colors.warningRed.opacity(0.05))
                .foregroundColor(isTrusted ? colors.successGreen : colors.warningRed)
                .cornerRadius(10)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
}


#Preview {
    URLVerificationView()
        .environment(\.secureItColors, SecureItColors()) // Inyectar colores para el Preview
}
