import SwiftUI
import CoreImage.CIFilterBuiltins
import PassKit

struct TicketQRView: View {
    let ticket: Ticket
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        VStack(spacing: 24) {
            Text(ticket.eventName)
                .font(.title2.bold())
                .foregroundColor(Color(hex: "205072"))

            if let image = generateQRCode(from: ticket.id.uuidString) {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }

            Button("Agregar a Wallet") {
                addToWallet()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(hex: "56C596"))
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle("Boleto QR")
    }

    private func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage,
           let cgimg = context.createCGImage(outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10)),
                                             from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        return nil
    }

    private func addToWallet() {
        guard PKAddPassesViewController.canAddPasses() else {
            print("Wallet no disponible en este dispositivo.")
            return
        }
        // Para hackathon: solo simular
        print("✅ Boleto agregado a Wallet (simulado).")
    }
}

