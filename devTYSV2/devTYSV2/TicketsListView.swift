import SwiftUI

struct TicketsListView: View {
    @ObservedObject var ticketManager = TicketManager.shared

    var body: some View {
        NavigationView {
            VStack {
                if ticketManager.tickets.isEmpty {
                    Text("Aún no tienes boletos guardados 🎟️")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(ticketManager.tickets) { ticket in
                        NavigationLink(destination: TicketQRView(ticket: ticket)) {
                            VStack(alignment: .leading) {
                                Text(ticket.eventName)
                                    .font(.headline)
                                Text("Asiento: \(ticket.seat)")
                                Text("Fecha: \(ticket.date)")
                                    .font(.caption)
                            }
                        }
                    }
                }

                Button("Comprar / Generar Boleto") {
                    ticketManager.addTicket(
                        eventName: "Final Mundial 2026",
                        date: "19 Julio 2026",
                        seat: "A\(Int.random(in: 1...120))",
                        price: 199.99
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: "329D9C"))
                .padding()
            }
            .navigationTitle("Mis Boletos")
        }
    }
}

