//
//  TicketVerificationView.swift
//  SECURE-IT - Vista de Verificación Mejorada
//
//  Verificación de boletos con diseño moderno y paleta consistente

import SwiftUI

struct TicketVerificationView: View {
    @State private var selectedCountry: String? = nil
    @State private var ticketImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var showingVerification = false
    @State private var verificationResult: VerificationResult?
    @State private var showMainView = false
    @State private var isAnalyzing = false
    
    enum VerificationResult {
        case cloned
        case authentic
    }
    
    // Paleta SECURE-IT
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    var body: some View {
        if showMainView {
            MainVerificationView()
        } else if showingVerification {
            TicketVerificationResultView(
                result: verificationResult ?? .cloned,
                onScanAnother: {
                    resetVerification()
                },
                onReportToFIFA: {
                    // Handle report to FIFA
                },
                onDownloadCertificate: {
                    // Handle download certificate
                },
                onBackToMain: {
                    showMainView = true
                }
            )
        } else {
            ZStack {
                // Fondo con gradiente
                LinearGradient(
                    gradient: Gradient(colors: [
                        primaryTeal.opacity(0.08),
                        primaryPale.opacity(0.15),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Button(action: {
                                showMainView = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Volver")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .foregroundColor(primaryTeal)
                            }
                            
                            Spacer()
                            
                            Text("Verificar Boleto")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(primaryDark)
                            
                            Spacer()
                            
                            // Spacer invisible
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Volver")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.clear)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                        
                        // Hero icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryTeal.opacity(0.15), primaryGreen.opacity(0.15)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryTeal, primaryGreen]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 90, height: 90)
                                .shadow(color: primaryTeal.opacity(0.4), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 28)
                        
                        // Título y descripción
                        VStack(spacing: 12) {
                            Text("Selecciona el país")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(primaryDark)
                            
                            Text("Esto mejorará la precisión del análisis de IA")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 32)
                        
                        // Selección de país
                        VStack(spacing: 14) {
                            CountryButtonImproved(
                                countryName: "México",
                                flagEmoji: "🇲🇽",
                                isSelected: selectedCountry == "México",
                                primaryColor: primaryTeal,
                                accentColor: primaryGreen
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedCountry = "México"
                                }
                            }
                            
                            CountryButtonImproved(
                                countryName: "Estados Unidos",
                                flagEmoji: "🇺🇸",
                                isSelected: selectedCountry == "Estados Unidos",
                                primaryColor: primaryTeal,
                                accentColor: primaryGreen
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedCountry = "Estados Unidos"
                                }
                            }
                            
                            CountryButtonImproved(
                                countryName: "Canadá",
                                flagEmoji: "🇨🇦",
                                isSelected: selectedCountry == "Canadá",
                                primaryColor: primaryTeal,
                                accentColor: primaryGreen
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedCountry = "Canadá"
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                        
                        // Preview de imagen si existe
                        if let ticketImage = ticketImage {
                            VStack(spacing: 16) {
                                HStack(spacing: 10) {
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(primaryGreen)
                                    
                                    Text("Vista previa del boleto")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(primaryDark)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation {
                                            self.ticketImage = nil
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.gray.opacity(0.6))
                                    }
                                }
                                
                                Image(uiImage: ticketImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 220)
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                            }
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 4)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                        }
                        
                        // Botón de carga
                        Button(action: {
                            if selectedCountry != nil {
                                showingImagePicker = true
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: ticketImage == nil ? "photo.badge.plus" : "checkmark.circle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text(ticketImage == nil ? "Cargar Boleto desde Galería" : "Cambiar Imagen")
                                    .font(.system(size: 17, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(
                                selectedCountry != nil ?
                                LinearGradient(
                                    gradient: Gradient(colors: [primaryTeal, primaryGreen]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ) :
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(29)
                            .shadow(color: selectedCountry != nil ? primaryGreen.opacity(0.4) : Color.clear, radius: 15, x: 0, y: 8)
                        }
                        .disabled(selectedCountry == nil)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        
                        // Botón analizar (solo si hay imagen)
                        if ticketImage != nil {
                            Button(action: {
                                simulateVerification()
                            }) {
                                HStack(spacing: 12) {
                                    if isAnalyzing {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        Text("Analizando...")
                                            .font(.system(size: 17, weight: .bold))
                                    } else {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 20, weight: .semibold))
                                        Text("Analizar con IA")
                                            .font(.system(size: 17, weight: .bold))
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryDark, primaryTeal]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(29)
                                .shadow(color: primaryDark.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                            .disabled(isAnalyzing)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 32)
                        }
                        
                        // Consejos importantes
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(primaryTeal.opacity(0.15))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "lightbulb.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(primaryTeal)
                                }
                                
                                Text("Consejos importantes")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                TipRow(
                                    icon: "globe.americas.fill",
                                    text: "Selecciona el país donde se jugará el partido",
                                    color: primaryGreen
                                )
                                
                                TipRow(
                                    icon: "camera.viewfinder",
                                    text: "Asegúrate de que la imagen sea clara y legible",
                                    color: primaryTeal
                                )
                                
                                TipRow(
                                    icon: "shield.checkered",
                                    text: "El boleto debe mostrar elementos de seguridad",
                                    color: primaryDark
                                )
                            }
                        }
                        .padding(20)
                        .background(primaryPale.opacity(0.3))
                        .cornerRadius(20)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 50)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $ticketImage, sourceType: .photoLibrary)
            }
        }
    }
    
    private func simulateVerification() {
        isAnalyzing = true
        
        // Simular proceso de verificación
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isAnalyzing = false
            verificationResult = Bool.random() ? .cloned : .authentic
            withAnimation {
                showingVerification = true
            }
        }
    }
    
    private func resetVerification() {
        selectedCountry = nil
        ticketImage = nil
        verificationResult = nil
        showingVerification = false
        isAnalyzing = false
    }
}

// COMPONENTE: Botón de país mejorado
struct CountryButtonImproved: View {
    let countryName: String
    let flagEmoji: String
    let isSelected: Bool
    let primaryColor: Color
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Bandera
                Text(flagEmoji)
                    .font(.system(size: 36))
                
                // Nombre
                Text(countryName)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
                
                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            gradient: Gradient(colors: [primaryColor, accentColor]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.white]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1.5)
            )
            .shadow(color: isSelected ? primaryColor.opacity(0.3) : Color.black.opacity(0.05), radius: isSelected ? 12 : 6, x: 0, y: isSelected ? 8 : 3)
        }
    }
}

// COMPONENTE: Fila de consejo
struct TipRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 28)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer(minLength: 0)
        }
    }
}

// VISTA DE RESULTADOS
struct TicketVerificationResultView: View {
    let result: TicketVerificationView.VerificationResult
    let onScanAnother: () -> Void
    let onReportToFIFA: () -> Void
    let onDownloadCertificate: () -> Void
    let onBackToMain: () -> Void
    
    @State private var showAnimation = false
    
    // Paleta SECURE-IT
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    var body: some View {
        ZStack {
            // Fondo
            LinearGradient(
                gradient: Gradient(colors: [
                    result == .authentic ? primaryPale.opacity(0.3) : Color.red.opacity(0.05),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: onBackToMain) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Inicio")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(primaryTeal)
                        }
                        
                        Spacer()
                        
                        Text("Resultado")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(primaryDark)
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Inicio")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.clear)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                    
                    if result == .cloned {
                        // BOLETO CLONADO
                        VStack(spacing: 28) {
                            // Ícono de advertencia
                            ZStack {
                                Circle()
                                    .fill(Color.red.opacity(0.1))
                                    .frame(width: 140, height: 140)
                                
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 110, height: 110)
                                    .shadow(color: Color.red.opacity(0.4), radius: 20, x: 0, y: 8)
                                
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(showAnimation ? 1.0 : 0.5)
                            .opacity(showAnimation ? 1.0 : 0)
                            
                            VStack(spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "xmark.shield.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.red)
                                    
                                    Text("Boleto Clonado")
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundColor(.red)
                                }
                                
                                Text("Se detectaron inconsistencias que indican que este boleto es una copia no autorizada")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 32)
                            }
                            
                            // Análisis detallado
                            AnalysisCard(
                                isAuthentic: false,
                                primaryTeal: primaryTeal,
                                primaryGreen: primaryGreen
                            )
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 32)
                        
                    } else {
                        // BOLETO AUTÉNTICO
                        VStack(spacing: 28) {
                            // Ícono de éxito
                            ZStack {
                                Circle()
                                    .fill(primaryGreen.opacity(0.15))
                                    .frame(width: 140, height: 140)
                                
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [primaryGreen, primaryLight]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 110, height: 110)
                                    .shadow(color: primaryGreen.opacity(0.4), radius: 20, x: 0, y: 8)
                                
                                Image(systemName: "checkmark.shield.fill")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(showAnimation ? 1.0 : 0.5)
                            .opacity(showAnimation ? 1.0 : 0)
                            
                            VStack(spacing: 12) {
                                Text("¡Boleto Auténtico!")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(primaryGreen)
                                
                                Text("Este boleto ha pasado todas las verificaciones oficiales de seguridad FIFA 2026")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 32)
                            }
                            
                            // Análisis detallado
                            AnalysisCard(
                                isAuthentic: true,
                                primaryTeal: primaryTeal,
                                primaryGreen: primaryGreen
                            )
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 32)
                    }
                    
                    // Botones de acción
                    VStack(spacing: 14) {
                        if result == .cloned {
                            Button(action: onScanAnother) {
                                HStack(spacing: 12) {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                    Text("Escanear Otro Boleto")
                                        .font(.system(size: 17, weight: .bold))
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
                                .shadow(color: primaryTeal.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                            
                            Button(action: onReportToFIFA) {
                                HStack(spacing: 12) {
                                    Image(systemName: "exclamationmark.bubble.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                    Text("Reportar a FIFA")
                                        .font(.system(size: 17, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(Color.red)
                                .cornerRadius(29)
                                .shadow(color: Color.red.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                        } else {
                            Button(action: onDownloadCertificate) {
                                HStack(spacing: 12) {
                                    Image(systemName: "arrow.down.doc.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                    Text("Descargar Certificado")
                                        .font(.system(size: 17, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryGreen, primaryLight]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(29)
                                .shadow(color: primaryGreen.opacity(0.4), radius: 15, x: 0, y: 8)
                            }
                            
                            Button(action: onScanAnother) {
                                HStack(spacing: 12) {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                    Text("Verificar Otro Boleto")
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
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showAnimation = true
            }
        }
    }
}

// COMPONENTE: Card de análisis
struct AnalysisCard: View {
    let isAuthentic: Bool
    let primaryTeal: Color
    let primaryGreen: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "chart.bar.doc.horizontal.fill")
                    .font(.system(size: 18))
                    .foregroundColor(isAuthentic ? primaryGreen : .red)
                
                Text("Análisis Detallado")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            VStack(spacing: 12) {
                AnalysisRow(
                    label: "Confianza IA",
                    value: isAuthentic ? "98.7%" : "91.3%",
                    isPositive: isAuthentic,
                    color: isAuthentic ? primaryGreen : .red
                )
                
                AnalysisRow(
                    label: "Tiempo de análisis",
                    value: "2.8s",
                    isPositive: true,
                    color: .gray
                )
                
                AnalysisRow(
                    label: "Logo FIFA oficial",
                    value: isAuthentic ? "Detectado" : "No detectado",
                    isPositive: isAuthentic,
                    color: isAuthentic ? primaryTeal : .red
                )
                
                AnalysisRow(
                    label: "Código QR único",
                    value: isAuthentic ? "Válido" : "Duplicado",
                    isPositive: isAuthentic,
                    color: isAuthentic ? primaryGreen : .red
                )
                
                AnalysisRow(
                    label: "Hologramas",
                    value: isAuthentic ? "Verificados" : "Ausentes",
                    isPositive: isAuthentic,
                    color: isAuthentic ? primaryTeal : .red
                )
                
                AnalysisRow(
                    label: "Base de datos FIFA",
                    value: isAuthentic ? "Registrado" : "No encontrado",
                    isPositive: isAuthentic,
                    color: isAuthentic ? primaryGreen : .red
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 4)
    }
}

// COMPONENTE: Fila de análisis
struct AnalysisRow: View {
    let label: String
    let value: String
    let isPositive: Bool
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: isPositive ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
            }
        }
    }
}

#Preview {
    TicketVerificationView()
}
