import Foundation

class TicketManager: ObservableObject {
    static let shared = TicketManager()
    @Published var tickets: [Ticket] = []

    private let key = "SavedTickets"

    init() {
        loadTickets()
    }

    func addTicket(eventName: String, date: String, seat: String, price: Double) {
        let ticket = Ticket(eventName: eventName, date: date, seat: seat, price: price)
        tickets.append(ticket)
        saveTickets()
    }

    func saveTickets() {
        if let encoded = try? JSONEncoder().encode(tickets) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func loadTickets() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Ticket].self, from: data) {
            tickets = decoded
        }
    }
}

