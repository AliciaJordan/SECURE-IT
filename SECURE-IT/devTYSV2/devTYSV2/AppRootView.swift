//
//  AppRootView.swift
//  SECURE-IT - Vista Raíz
//
//  Maneja el flujo de navegación inicial

import SwiftUI

struct AppRootView: View {
    @StateObject private var userManager = UserManager.shared
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                // Splash Screen
                SplashScreenView()
            } else {
                // Decidir qué vista mostrar
                if !userManager.hasCompletedOnboarding() {
                    // Primera vez - Mostrar onboarding
                    OnboardingView()
                } else if userManager.isLoggedIn {
                    // Usuario ya logueado - Ir directo a main
                    MainVerificationView()
                } else {
                    // Ya completó onboarding pero no está logueado - Mostrar login
                    LoginView()
                }
            }
        }
        .onAppear {
            // Simular carga inicial
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}

// SPLASH SCREEN
struct SplashScreenView: View {
    @State private var animate = false
    
    // Paleta SECURE-IT
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    var body: some View {
        ZStack {
            // Fondo con gradiente
            LinearGradient(
                gradient: Gradient(colors: [primaryTeal, primaryGreen]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Logo hexagonal animado
                ZStack {
                    // Anillos de fondo
                    ForEach(0..<3) { index in
                        HexagonShape()
                            .stroke(Color.white.opacity(0.2), lineWidth: 3)
                            .frame(width: 140 + CGFloat(index * 30), height: 140 + CGFloat(index * 30))
                            .scaleEffect(animate ? 1.2 : 1.0)
                            .opacity(animate ? 0.0 : 1.0)
                            .animation(
                                Animation.easeOut(duration: 1.5)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.3),
                                value: animate
                            )
                    }
                    
                    // Logo principal
                    ZStack {
                        HexagonShape()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                        
                        HexagonShape()
                            .stroke(primaryTeal.opacity(0.3), lineWidth: 3)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "shield.checkered.fill")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(primaryGreen)
                    }
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: animate
                    )
                }
                
                VStack(spacing: 8) {
                    Text("SECURE-IT")
                        .font(.system(size: 38, weight: .black))
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    Text("FIFA 2026")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(3)
                }
                
                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                    .padding(.top, 20)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    AppRootView()
}
