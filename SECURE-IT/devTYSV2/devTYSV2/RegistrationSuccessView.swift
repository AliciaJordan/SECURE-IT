//
//  RegistrationSuccessView.swift
//  SECURE-IT - Vista de Éxito Mejorada
//
//  Vista de confirmación con diseño moderno y paleta consistente

import SwiftUI

struct RegistrationSuccessView: View {
    let clientID: String
    @State private var showMainView = false
    @State private var showConfetti = false
    @State private var scaleAnimation: CGFloat = 0.5
    @State private var checkmarkScale: CGFloat = 0.0
    @State private var idCopied = false
    
    // Paleta SECURE-IT
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    var body: some View {
        if showMainView {
            MainVerificationView()
        } else {
            ZStack {
                // Fondo con gradiente
                LinearGradient(
                    gradient: Gradient(colors: [primaryPale.opacity(0.3), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Confetti animado (opcional)
                if showConfetti {
                    ConfettiView()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 60)
                        
                        // Ícono de éxito con animación
                        ZStack {
                            // Círculo de fondo con pulso
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryGreen.opacity(0.2), primaryLight.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .scaleEffect(scaleAnimation)
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryGreen, primaryLight]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .scaleEffect(scaleAnimation)
                            
                            // Checkmark
                            Image(systemName: "checkmark")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                                .scaleEffect(checkmarkScale)
                        }
                        .padding(.bottom, 32)
                        
                        // Título principal
                        VStack(spacing: 12) {
                            Text("¡Registro Exitoso!")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(primaryDark)
                            
                            Text("Tu cuenta ha sido creada\nsuccessfully")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        .padding(.bottom, 40)
                        
                        // Card del ID de Cliente
                        VStack(spacing: 20) {
                            HStack(spacing: 10) {
                                Image(systemName: "person.text.rectangle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(primaryTeal)
                                
                                Text("Tu ID de Cliente")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(primaryDark)
                            }
                            
                            // ID Display con gradiente
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [primaryTeal, primaryGreen]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 70)
                                    .shadow(color: primaryGreen.opacity(0.4), radius: 15, x: 0, y: 8)
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "shield.checkered.fill")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.9))
                                    
                                    Text(clientID)
                                        .font(.system(size: 19, weight: .bold))
                                        .foregroundColor(.white)
                                        .tracking(1)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Nota de guardado
                            HStack(spacing: 10) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(primaryTeal)
                                
                                Text("Guarda este ID, lo necesitarás para verificar tus boletos")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 4)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                        
                        // Botones de acción
                        VStack(spacing: 14) {
                            // Botón Copiar ID
                            Button(action: {
                                UIPasteboard.general.string = clientID
                                withAnimation(.spring(response: 0.3)) {
                                    idCopied = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation(.spring(response: 0.3)) {
                                        idCopied = false
                                    }
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: idCopied ? "checkmark.circle.fill" : "doc.on.doc.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text(idCopied ? "¡ID Copiado!" : "Copiar ID")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(idCopied ? primaryGreen : primaryTeal)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(idCopied ? primaryGreen : primaryTeal, lineWidth: 2)
                                )
                                .cornerRadius(28)
                            }
                            
                            // Botón Ir al Inicio
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showMainView = true
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Text("Ir al Inicio")
                                        .font(.system(size: 17, weight: .bold))
                                    
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryTeal, primaryGreen]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(28)
                                .shadow(color: primaryGreen.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                        
                        // Card de beneficios
                        VStack(spacing: 16) {
                            HStack(spacing: 10) {
                                Image(systemName: "star.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(primaryGreen)
                                
                                Text("¿Qué puedes hacer ahora?")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Spacer()
                            }
                            
                            BenefitRow(
                                icon: "camera.fill",
                                text: "Registrar tus boletos FIFA 2026",
                                color: primaryGreen
                            )
                            
                            BenefitRow(
                                icon: "checkmark.shield.fill",
                                text: "Verificar autenticidad en segundos",
                                color: primaryTeal
                            )
                            
                            BenefitRow(
                                icon: "link.circle.fill",
                                text: "Validar URLs oficiales de compra",
                                color: primaryDark
                            )
                        }
                        .padding(20)
                        .background(primaryPale.opacity(0.3))
                        .cornerRadius(20)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                        
                        // Nota importante
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "exclamationmark.shield.fill")
                                .font(.system(size: 22))
                                .foregroundColor(primaryTeal)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Importante")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Text("Mantén tu ID seguro. Es tu llave personal para acceder a todas las funciones de SECURE-IT.")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.gray)
                                    .lineSpacing(3)
                            }
                        }
                        .padding(18)
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(primaryTeal.opacity(0.3), lineWidth: 1.5)
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 50)
                    }
                }
            }
            .onAppear {
                // Animaciones de entrada
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    scaleAnimation = 1.0
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2)) {
                    checkmarkScale = 1.0
                }
                
                // Confetti opcional
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        showConfetti = true
                    }
                }
                
                // Ocultar confetti después de 3 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showConfetti = false
                    }
                }
            }
        }
    }
}

// COMPONENTE: Fila de beneficio
struct BenefitRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 32)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(color)
        }
    }
}

// COMPONENTE: Confetti animado (simple)
struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<30) { index in
                ConfettiPiece(
                    color: [
                        Color(hex: "56C596"),
                        Color(hex: "329D9C"),
                        Color(hex: "7BE495"),
                        Color(hex: "CFF4D2")
                    ].randomElement() ?? Color.green,
                    animate: $animate
                )
                .offset(
                    x: CGFloat.random(in: -200...200),
                    y: animate ? 1000 : -100
                )
                .rotationEffect(.degrees(animate ? 360 : 0))
                .animation(
                    Animation.linear(duration: Double.random(in: 2...4))
                        .delay(Double.random(in: 0...0.5)),
                    value: animate
                )
            }
        }
        .onAppear {
            animate = true
        }
        .allowsHitTesting(false)
    }
}

// COMPONENTE: Pieza de confetti
struct ConfettiPiece: View {
    let color: Color
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
    }
}

#Preview {
    RegistrationSuccessView(clientID: "FIFA2026-6JTBFR2")
}
