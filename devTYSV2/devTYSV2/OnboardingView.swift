//
//  OnboardingView.swift
//  SECURE-IT - Onboarding Mejorado
//
//  Vista de bienvenida con tortuga hexagonal animada

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainView = false
    @State private var logoScale: CGFloat = 0.8
    
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
                // Fondo con gradiente dinámico según página
                LinearGradient(
                    gradient: Gradient(colors: [
                        currentPage == 0 ? primaryPale.opacity(0.4) :
                        currentPage == 1 ? primaryLight.opacity(0.3) :
                        primaryTeal.opacity(0.2),
                        Color.white
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 0) {
                    // Logo SECURE-IT en header
                    HStack(spacing: 12) {
                        AnimatedHexagonLogo(
                            size: 44,
                            colors: [primaryGreen, primaryTeal],
                            scale: logoScale
                        )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("SECURE-IT")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(primaryDark)
                            Text("FIFA 2026")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(primaryTeal)
                                .tracking(1.5)
                        }
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                    
                    // Contenido de páginas
                    TabView(selection: $currentPage) {
                        // Página 1: Bienvenida
                        OnboardingPage1(
                            primaryDark: primaryDark,
                            primaryTeal: primaryTeal,
                            primaryGreen: primaryGreen,
                            primaryLight: primaryLight,
                            primaryPale: primaryPale
                        )
                        .tag(0)
                        
                        // Página 2: IA
                        OnboardingPage2(
                            primaryDark: primaryDark,
                            primaryTeal: primaryTeal,
                            primaryGreen: primaryGreen,
                            primaryLight: primaryLight,
                            primaryPale: primaryPale
                        )
                        .tag(1)
                        
                        // Página 3: Protección
                        OnboardingPage3(
                            primaryDark: primaryDark,
                            primaryTeal: primaryTeal,
                            primaryGreen: primaryGreen,
                            primaryLight: primaryLight,
                            primaryPale: primaryPale
                        )
                        .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onChange(of: currentPage) { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            logoScale = 1.0
                        }
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1)) {
                            logoScale = 0.8
                        }
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // Indicadores de página personalizados
                    HStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ?
                                      LinearGradient(
                                        gradient: Gradient(colors: [primaryTeal, primaryGreen]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                      ) :
                                      LinearGradient(
                                        gradient: Gradient(colors: [primaryPale, primaryPale]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                      ))
                                .frame(width: index == currentPage ? 40 : 10, height: 10)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // Botón de acción principal
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showMainView = true
                            }
                        }
                    }) {
                        HStack(spacing: 12) {
                            Text(currentPage == 2 ? "Comenzar" : "Siguiente")
                                .font(.system(size: 18, weight: .bold))
                            
                            Image(systemName: currentPage == 2 ? "checkmark.shield.fill" : "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
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
                    .padding(.horizontal, 28)
                    .padding(.bottom, currentPage < 2 ? 16 : 50)
                    
                    // Botón Skip (solo páginas 1 y 2)
                    if currentPage < 2 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showMainView = true
                            }
                        }) {
                            Text("Saltar")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(primaryTeal.opacity(0.6))
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

// PÁGINA 1: BIENVENIDA
struct OnboardingPage1: View {
    let primaryDark: Color
    let primaryTeal: Color
    let primaryGreen: Color
    let primaryLight: Color
    let primaryPale: Color
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Espacio para tu PNG de tortuga
            ZStack {
                Circle()
                    .fill(primaryPale.opacity(0.4))
                    .frame(width: 180, height: 180)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .opacity(isAnimating ? 0.5 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                // Placeholder para PNG
                Image("tortuga")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .opacity(0.95)

            }
            .frame(height: 180)
            .onAppear {
                isAnimating = true
            }
            
            Spacer()
                .frame(height: 8)
            
            VStack(spacing: 10) {
                Text("Bienvenido a")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(primaryTeal)
                
                Text("SECURE-IT")
                    .font(.system(size: 34, weight: .black))
                    .foregroundColor(primaryDark)
                    .tracking(1)
                
                Text("Tu guardián de confianza para\nboletos FIFA 2026")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
                .frame(height: 16)
            
            // Badge de características
            HStack(spacing: 12) {
                FeatureBadge(icon: "bolt.fill", text: "Rápido", color: .yellow)
                FeatureBadge(icon: "shield.checkered", text: "Seguro", color: primaryGreen)
                FeatureBadge(icon: "brain.head.profile", text: "IA", color: primaryTeal)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
}

// PÁGINA 2: INTELIGENCIA ARTIFICIAL
struct OnboardingPage2: View {
    let primaryDark: Color
    let primaryTeal: Color
    let primaryGreen: Color
    let primaryLight: Color
    let primaryPale: Color
    
    @State private var isScanning = false
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Espacio para tu PNG de tortuga con efecto de escaneo
            ZStack {
                // Anillos de escaneo
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(primaryTeal.opacity(0.3), lineWidth: 2)
                        .frame(width: 140 + CGFloat(index * 28), height: 140 + CGFloat(index * 28))
                        .scaleEffect(isScanning ? 1.3 : 1.0)
                        .opacity(isScanning ? 0.0 : 0.6)
                        .animation(
                            Animation.easeOut(duration: 2.0)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.3),
                            value: isScanning
                        )
                }
                
                // Placeholder para PNG
                Image("tortuga")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .opacity(0.95)

                
                // Icono de IA flotante
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(primaryGreen)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(color: primaryGreen.opacity(0.3), radius: 8)
                    )
                    .offset(x: 55, y: -45)
                    .scaleEffect(isScanning ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: isScanning
                    )
            }
            .frame(height: 180)
            .onAppear {
                isScanning = true
            }
            
            Spacer()
                .frame(height: 8)
            
            VStack(spacing: 10) {
                Text("Inteligencia Artificial")
                    .font(.system(size: 29, weight: .bold))
                    .foregroundColor(primaryDark)
                    .multilineTextAlignment(.center)
                
                Text("Detectamos boletos clonados con\nprecisión del 99.2%")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
                .frame(height: 16)
            
            // Stats Cards
            HStack(spacing: 12) {
                StatCard(value: "99.2%", label: "Precisión", color: primaryGreen)
                StatCard(value: "<2s", label: "Análisis", color: primaryTeal)
            }
            .padding(.horizontal, 28)
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
}

// PÁGINA 3: PROTECCIÓN
struct OnboardingPage3: View {
    let primaryDark: Color
    let primaryTeal: Color
    let primaryGreen: Color
    let primaryLight: Color
    let primaryPale: Color
    
    @State private var shieldScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Espacio para tu PNG de tortuga con escudo
            ZStack {
                // Escudo de fondo
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [primaryDark.opacity(0.1), primaryTeal.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(shieldScale)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: shieldScale
                    )
                
                // Placeholder para PNG
                // Placeholder para PNG
                Image("tortuga")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .opacity(0.95)

                
                // Escudo flotante
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(primaryGreen)
                    .shadow(color: primaryGreen.opacity(0.5), radius: 20)
                    .offset(y: 70)
            }
            .frame(height: 180)
            .onAppear {
                shieldScale = 1.15
            }
            
            Spacer()
                .frame(height: 8)
            
            VStack(spacing: 10) {
                Text("Protección Total")
                    .font(.system(size: 29, weight: .bold))
                    .foregroundColor(primaryDark)
                    .multilineTextAlignment(.center)
                
                Text("Evita fraudes y asegura que tu\nboleto sea 100% auténtico")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
                .frame(height: 16)
            
            // Security features
            VStack(spacing: 9) {
                SecurityFeature(icon: "lock.shield.fill", text: "Encriptación de datos", color: primaryGreen)
                SecurityFeature(icon: "qrcode.viewfinder", text: "Verificación QR instantánea", color: primaryTeal)
                SecurityFeature(icon: "checkmark.seal.fill", text: "Certificación FIFA oficial", color: primaryDark)
            }
            .padding(.horizontal, 28)
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
}

// COMPONENTES AUXILIARES

// Logo hexagonal animado
struct AnimatedHexagonLogo: View {
    let size: CGFloat
    let colors: [Color]
    let scale: CGFloat
    
    var body: some View {
        ZStack {
            HexagonShape()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            
            // Patrón interno simplificado
            HexagonShape()
                .stroke(Color.white.opacity(0.4), lineWidth: 2)
                .frame(width: size * 0.5, height: size * 0.5)
        }
        .scaleEffect(scale)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: scale)
    }
}

// Badge de característica
struct FeatureBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            Text(text)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 65)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

// Card de estadística
struct StatCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 75)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

// Característica de seguridad
struct SecurityFeature: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 11) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 32)
            
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 15))
                .foregroundColor(color)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}

// Forma hexagonal
struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    OnboardingView()
}
