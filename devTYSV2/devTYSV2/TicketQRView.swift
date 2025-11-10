import SwiftUI
import CoreImage.CIFilterBuiltins
import PassKit
import UIKit

struct TicketQRView: View {
    let ticket: Ticket
    @State private var showWalletAlert = false
    @State private var walletAlertMessage = ""
    @State private var qrScale: CGFloat = 0.8
    @State private var isAnimating = false
    
    // Paleta SECURE-IT
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
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
                VStack(spacing: 28) {
                    // Header del evento
                    VStack(spacing: 12) {
                        Text(ticket.eventName)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(primaryDark)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            InfoBadge(icon: "calendar", text: ticket.date, color: primaryTeal)
                            InfoBadge(icon: "chair", text: ticket.seat, color: primaryGreen)
                            InfoBadge(icon: "dollarsign.circle", text: String(format: "$%.2f", ticket.price), color: primaryDark)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // Tarjeta del QR
                    VStack(spacing: 20) {
                        Text("Código QR del Boleto")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(primaryDark)
                        
                        if let image = generateQRCode(from: ticket.id.uuidString) {
                            Image(uiImage: image)
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 240, height: 240)
                                .padding(20)
                                .background(
                                    ZStack {
                                        Color.white
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [primaryTeal.opacity(0.3), primaryGreen.opacity(0.3)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    }
                                )
                                .cornerRadius(20)
                                .shadow(color: primaryDark.opacity(0.15), radius: 20, x: 0, y: 10)
                                .scaleEffect(qrScale)
                                .onAppear {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                        qrScale = 1.0
                                    }
                                }
                        }
                        
                        Text("Escanea este código para verificar tu boleto")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
                    .padding(.horizontal, 24)
                    
                    // Botón de Wallet
                    if PassKitHelper.shared.canAddPasses() {
                        Button(action: addToWallet) {
                            HStack(spacing: 12) {
                                Image(systemName: "wallet.pass.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                
                                Text("Agregar a Apple Wallet")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [primaryGreen, primaryTeal]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: primaryGreen.opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        .padding(.horizontal, 24)
                        .scaleEffect(isAnimating ? 0.95 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: isAnimating)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.orange)
                            
                            Text("Apple Wallet no está disponible en este dispositivo")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                    }
                    
                    // Información adicional
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(primaryTeal)
                            Text("Este boleto es único e intransferible")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            Image(systemName: "shield.checkered.fill")
                                .foregroundColor(primaryGreen)
                            Text("Verificado con tecnología SECURE-IT")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    .padding(16)
                    .background(primaryPale.opacity(0.5))
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationTitle("Boleto QR")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Wallet", isPresented: $showWalletAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(walletAlertMessage)
        }
    }

    private func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }

    private func addToWallet() {
        isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isAnimating = false
        }
        
        guard PassKitHelper.shared.canAddPasses() else {
            walletAlertMessage = "Apple Wallet no está disponible en este dispositivo."
            showWalletAlert = true
            return
        }
        
        guard let pass = PassKitHelper.shared.createPass(for: ticket) else {
            walletAlertMessage = "No se pudo crear el pass. Por favor, intenta nuevamente."
            showWalletAlert = true
            return
        }
        
        // Obtener el view controller actual
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            
            // Encontrar el view controller más superior
            var topController = rootViewController
            while let presented = topController.presentedViewController {
                topController = presented
            }
            
            PassKitHelper.shared.addPassToWallet(pass, from: topController) { success in
                DispatchQueue.main.async {
                    if success {
                        walletAlertMessage = "✅ El boleto se agregó correctamente a tu Apple Wallet."
                    } else {
                        walletAlertMessage = "❌ No se pudo agregar el boleto al Wallet. Por favor, intenta nuevamente."
                    }
                    showWalletAlert = true
                }
            }
        } else {
            walletAlertMessage = "No se pudo acceder a la interfaz. Por favor, intenta nuevamente."
            showWalletAlert = true
        }
    }
}

// Componente: Badge de información
struct InfoBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundColor(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.15))
        .cornerRadius(8)
    }
}

