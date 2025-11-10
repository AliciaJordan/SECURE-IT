//
//  MainVerificationView.swift
//  SECURE-IT - Vista Principal Mejorada
//
//  Home con más énfasis en azul y diseño moderno

import SwiftUI

struct MainVerificationView: View {
    @State private var showRegistration = false
    @State private var showURLVerification = false
    @State private var showTicketVerification = false
    @State private var animateLogo = false
    
    // Paleta SECURE-IT (más énfasis en azules)
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    var body: some View {
        if showRegistration {
            UserRegistrationView()
        } else if showURLVerification {
            URLVerificationView()
        } else if showTicketVerification {
            TicketVerificationView()
        } else {
            ZStack {
                // Fondo con gradiente balanceado azul-verde
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
                        // Header con logo
                        HStack(spacing: 14) {
                            // Logo hexagonal
                            ZStack {
                                HexagonShape()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [primaryDark, primaryTeal]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 48, height: 48)
                                    .shadow(color: primaryDark.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                // Patrón interno
                                HexagonShape()
                                    .stroke(Color.white.opacity(0.4), lineWidth: 2)
                                    .frame(width: 24, height: 24)
                            }
                            .rotationEffect(.degrees(animateLogo ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 20)
                                    .repeatForever(autoreverses: false),
                                value: animateLogo
                            )
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("SECURE-IT")
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(primaryDark)
                                    .tracking(0.5)
                                
                                Text("Verificador Oficial FIFA")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(primaryTeal)
                                    .tracking(1.2)
                            }
                            
                            Spacer()
                            
                            // Botón de perfil
                            Button(action: {}) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [primaryDark.opacity(0.1), primaryTeal.opacity(0.1)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 48, height: 48)
                                    
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 26))
                                        .foregroundColor(primaryTeal)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 28)
                        
                        // Hero Section
                        VStack(spacing: 20) {
                            // Ícono principal con animación
                            ZStack {
                                // Círculos de fondo azules
                                Circle()
                                    .fill(primaryDark.opacity(0.08))
                                    .frame(width: 140, height: 140)
                                
                                Circle()
                                    .fill(primaryTeal.opacity(0.12))
                                    .frame(width: 110, height: 110)
                                
                                // Escudo con gradiente azul
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [primaryDark, primaryTeal]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: "checkmark.shield.fill")
                                        .font(.system(size: 40, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .shadow(color: primaryTeal.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                            .scaleEffect(animateLogo ? 1.0 : 0.9)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: animateLogo
                            )
                            
                            VStack(spacing: 12) {
                                Text("Mundial FIFA 2026")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Text("Verifica la autenticidad de tus boletos oficiales con tecnología de IA avanzada")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 32)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.bottom, 36)
                        
                        // Botones principales
                        VStack(spacing: 14) {
                            // Verificar boleto - Botón primario azul
                            MainActionButton(
                                icon: "checkmark.shield.fill",
                                title: "Verificar Boleto",
                                subtitle: "Escanea y valida tu ticket",
                                gradient: LinearGradient(
                                    gradient: Gradient(colors: [primaryDark, primaryTeal]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                isPrimary: true,
                                action: {
                                    showTicketVerification = true
                                }
                            )
                            
                            // Registrar boleto - Secondary azul outline
                            MainActionButton(
                                icon: "camera.fill",
                                title: "Registrar Boleto",
                                subtitle: "Vincula tu ticket a tu ID",
                                outlineColor: primaryTeal,
                                action: {
                                    showRegistration = true
                                }
                            )
                            
                            // Verificar URL - Terciario azul suave
                            MainActionButton(
                                icon: "link.circle.fill",
                                title: "Verificar URL Oficial",
                                subtitle: "Confirma sitios seguros",
                                gradient: LinearGradient(
                                    gradient: Gradient(colors: [primaryTeal.opacity(0.8), primaryDark.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                isPrimary: true,
                                action: {
                                    showURLVerification = true
                                }
                            )
                            MainActionButton(
                                icon: "qrcode.viewfinder",
                                title: "Mis Boletos y QR",
                                subtitle: "Visualiza tus tickets guardados",
                                gradient: LinearGradient(
                                    gradient: Gradient(colors: [primaryGreen, primaryTeal]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                isPrimary: true,
                                action: {
                                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                                    windowScene?.windows.first?.rootViewController = UIHostingController(rootView: TicketsListView())
                                }
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                        
                        // Features destacadas con más azul
                        VStack(spacing: 16) {
                            HStack(spacing: 10) {
                                Image(systemName: "star.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(primaryTeal)
                                
                                Text("Características")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            
                            HStack(spacing: 12) {
                                FeatureCard(
                                    icon: "bolt.fill",
                                    title: "Instantáneo",
                                    description: "< 2 segundos",
                                    color: primaryDark
                                )
                                
                                FeatureCard(
                                    icon: "shield.checkered",
                                    title: "Seguro",
                                    description: "Encriptado",
                                    color: primaryTeal
                                )
                                
                                FeatureCard(
                                    icon: "chart.line.uptrend.xyaxis",
                                    title: "Preciso",
                                    description: "99.2%",
                                    color: primaryDark.opacity(0.8)
                                )
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 32)
                        
                        // Estadísticas con fondo azul
                        VStack(spacing: 20) {
                            HStack(spacing: 10) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(primaryDark)
                                
                                Text("Estadísticas en Tiempo Real")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            
                            // Card de estadísticas con gradiente azul
                            VStack(spacing: 0) {
                                // Header azul
                                HStack {
                                    Image(systemName: "globe.americas.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                    
                                    Text("Red Global SECURE-IT")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 8, height: 8)
                                    
                                    Text("ACTIVO")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryDark, primaryTeal]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                
                                // Stats grid
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        StatItem(
                                            value: "8,432",
                                            label: "Boletos\nVerificados",
                                            color: primaryTeal
                                        )
                                        
                                        Divider()
                                            .frame(height: 60)
                                        
                                        StatItem(
                                            value: "99.2%",
                                            label: "Precisión\nIA",
                                            color: primaryDark
                                        )
                                    }
                                    
                                    Divider()
                                    
                                    HStack(spacing: 0) {
                                        StatItem(
                                            value: "156",
                                            label: "Fraudes\nDetectados",
                                            color: .red.opacity(0.8)
                                        )
                                        
                                        Divider()
                                            .frame(height: 60)
                                        
                                        StatItem(
                                            value: "24/7",
                                            label: "Protección\nActiva",
                                            color: primaryTeal
                                        )
                                    }
                                }
                                .background(Color.white)
                            }
                            .cornerRadius(20)
                            .shadow(color: primaryDark.opacity(0.15), radius: 15, x: 0, y: 8)
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 32)
                        
                        // Sección de confianza con azul
                        VStack(spacing: 16) {
                            HStack(spacing: 10) {
                                Image(systemName: "rosette.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(primaryDark)
                                
                                Text("Certificación Oficial")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            
                            VStack(spacing: 12) {
                                TrustBadge(
                                    icon: "checkmark.seal.fill",
                                    text: "Autorizado por FIFA 2026",
                                    color: primaryDark
                                )
                                
                                TrustBadge(
                                    icon: "lock.shield.fill",
                                    text: "Certificado SSL A+ Rating",
                                    color: primaryTeal
                                )
                                
                                TrustBadge(
                                    icon: "building.columns.fill",
                                    text: "Verificado por Ticketmaster",
                                    color: primaryDark.opacity(0.8)
                                )
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 50)
                    }
                }
            }
            .onAppear {
                animateLogo = true
            }
        }
    }
}

// COMPONENTE: Botón de acción principal mejorado
struct MainActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    var gradient: LinearGradient?
    var outlineColor: Color?
    var isPrimary: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icono
                ZStack {
                    Circle()
                        .fill(isPrimary ? Color.white.opacity(0.2) : outlineColor?.opacity(0.1) ?? Color.clear)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(isPrimary ? .white : outlineColor)
                }
                
                // Texto
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(isPrimary ? .white : outlineColor)
                    
                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(isPrimary ? .white.opacity(0.8) : .gray)
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isPrimary ? .white.opacity(0.8) : outlineColor)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                Group {
                    if isPrimary {
                        gradient
                    } else {
                        Color.white
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(outlineColor ?? Color.clear, lineWidth: isPrimary ? 0 : 2)
            )
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(isPrimary ? 0.15 : 0.05), radius: isPrimary ? 12 : 6, x: 0, y: isPrimary ? 8 : 4)
        }
    }
}

// COMPONENTE: Feature Card con más azul
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

// COMPONENTE: Item de estadística
struct StatItem: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

// COMPONENTE: Trust Badge
struct TrustBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 40)
            
            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18))
                .foregroundColor(color)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    MainVerificationView()
}
