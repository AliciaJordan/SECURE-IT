import SwiftUI
import CoreImage.CIFilterBuiltins

struct TicketsListView: View {
    @ObservedObject var ticketManager = TicketManager.shared
    @State private var newTicketScale: CGFloat = 0.5
    @State private var newTicketOpacity: Double = 0.0
    @State private var isGenerating = false
    @Environment(\.presentationMode) var presentationMode
    var onDismiss: (() -> Void)? = nil
    
    // Paleta SECURE-IT
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        NavigationView {
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
                
                VStack(spacing: 0) {
                    if ticketManager.tickets.isEmpty {
                        // Vista vacía mejorada
                        VStack(spacing: 24) {
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(primaryTeal.opacity(0.1))
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: "ticket.fill")
                                    .font(.system(size: 50, weight: .light))
                                    .foregroundColor(primaryTeal)
                            }
                            
                            VStack(spacing: 12) {
                                Text("Aún no tienes boletos 🎟️")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Text("Genera tu primer boleto para comenzar")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Spacer()
                        }
                        .padding()
                    } else {
                        // Lista de boletos con ScrollView
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 20) {
                                ForEach(Array(ticketManager.tickets.enumerated()), id: \.element.id) { index, ticket in
                                    TicketCardView(
                                        ticket: ticket,
                                        index: index,
                                        primaryDark: primaryDark,
                                        primaryTeal: primaryTeal,
                                        primaryGreen: primaryGreen,
                                        primaryPale: primaryPale,
                                        generateQRCode: generateQRCode
                                    )
                                    .transition(.asymmetric(
                                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                                        removal: .scale(scale: 0.8).combined(with: .opacity)
                                    ))
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .padding(.bottom, 100)
                        }
                    }
                    
                    // Botón flotante para generar boleto
                    VStack {
                        Spacer()
                        
                        Button(action: generateNewTicket) {
                            HStack(spacing: 12) {
                                if isGenerating {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 22, weight: .semibold))
                                }
                                
                                Text(isGenerating ? "Generando..." : "Comprar / Generar Boleto")
                                    .font(.system(size: 17, weight: .bold))
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
                            .shadow(color: primaryGreen.opacity(0.4), radius: 15, x: 0, y: 8)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                        .disabled(isGenerating)
                    }
                }
            }
            .navigationTitle("Mis Boletos")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if let onDismiss = onDismiss {
                            onDismiss()
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.left")
                            Text("Volver")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(primaryTeal)
                    }
                }
            }
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 8, y: 8)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
    
    private func generateNewTicket() {
        isGenerating = true
        
        // Simular proceso de generación con animación
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                ticketManager.addTicket(
                    eventName: "Final Mundial 2026",
                    date: "19 Julio 2026",
                    seat: "A\(Int.random(in: 1...120))",
                    price: 199.99
                )
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isGenerating = false
            }
        }
    }
}

// Componente: Tarjeta de boleto mejorada
struct TicketCardView: View {
    let ticket: Ticket
    let index: Int
    let primaryDark: Color
    let primaryTeal: Color
    let primaryGreen: Color
    let primaryPale: Color
    let generateQRCode: (String) -> UIImage?
    
    @State private var cardScale: CGFloat = 0.9
    @State private var cardOpacity: Double = 0.0
    
    var body: some View {
        NavigationLink(destination: TicketQRView(ticket: ticket)) {
            VStack(spacing: 0) {
                // Header del boleto
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(ticket.eventName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(ticket.date)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    // Badge de asiento
                    VStack(spacing: 4) {
                        Text("ASIENTO")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(ticket.seat)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                }
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [primaryDark, primaryTeal]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                
                // Cuerpo del boleto con QR
                HStack(spacing: 20) {
                    // Información del boleto
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(icon: "calendar", text: ticket.date, color: primaryTeal)
                        InfoRow(icon: "chair", text: "Asiento \(ticket.seat)", color: primaryGreen)
                        InfoRow(icon: "dollarsign.circle", text: String(format: "$%.2f", ticket.price), color: primaryDark)
                    }
                    
                    Spacer()
                    
                    // QR Code
                    if let qrImage = generateQRCode(ticket.id.uuidString) {
                        Image(uiImage: qrImage)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(20)
                .background(Color.white)
                
                // Footer con acción
                HStack {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(primaryTeal)
                    
                    Text("Toca para ver detalles y agregar a Wallet")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(primaryTeal)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(primaryPale.opacity(0.5))
            }
            .cornerRadius(20)
            .shadow(color: primaryDark.opacity(0.15), radius: 15, x: 0, y: 8)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.1)) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
        }
    }
}

// Componente: Fila de información
struct InfoRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

