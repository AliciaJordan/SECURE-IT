import SwiftUI

struct ProfileView: View {
    @ObservedObject private var userManager = UserManager.shared
    
    // Paleta SECURE-IT
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [primaryTeal.opacity(0.08), primaryPale.opacity(0.15), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .foregroundColor(primaryTeal)
                            .shadow(radius: 10)
                        
                        Text(userManager.currentUser?.fullName ?? "Usuario")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(primaryDark)
                        
                        Text(userManager.currentUser?.email ?? "Correo no disponible")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 28)
                    
                    // Datos del usuario
                    ProfileSectionCard(
                        title: "Datos del Usuario",
                        items: [
                            ("ID Cliente", userManager.currentUser?.clientID ?? "-"),
                            ("Usuario", userManager.currentUser?.username ?? "-"),
                            ("Teléfono", userManager.currentUser?.phone ?? "-"),
                            ("Nacimiento", userManager.currentUser?.birthYear ?? "-"),
                            ("Nacionalidad", userManager.currentUser?.nationality ?? "-")
                        ],
                        icon: "person.fill",
                        iconColor: primaryGreen
                    )
                    
                    // Datos del boleto
                    if let ticket = userManager.ticket {
                        ProfileSectionCard(
                            title: "Boleto Registrado",
                            items: [
                                ("Número", ticket.number),
                                ("Partido", ticket.match),
                                ("Estado", ticket.status),
                                ("Fecha de Compra", DateFormatter.localizedString(from: ticket.purchaseDate, dateStyle: .medium, timeStyle: .none))
                            ],
                            icon: "ticket.fill",
                            iconColor: primaryTeal
                        )
                        
                        // Imagen del boleto, si existe
                        if let data = ticket.imageData, let image = UIImage(data: data) {
                            VStack(spacing: 8) {
                                Text("Imagen del Boleto")
                                    .font(.headline)
                                    .foregroundColor(primaryTeal)
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 180)
                                    .cornerRadius(16)
                                    .shadow(radius: 8)
                            }
                        }
                        
                        // Updates del boleto
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(primaryGreen)
                                Text("Actualizaciones")
                                    .font(.headline)
                                    .foregroundColor(primaryDark)
                                Spacer()
                            }
                            
                            ForEach(ticket.updates.sorted(by: { $0.date > $1.date })) { update in
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "chevron.right.circle")
                                        .foregroundColor(primaryGreen)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(update.message)
                                            .font(.system(size: 15, weight: .medium))
                                        Text(DateFormatter.localizedString(from: update.date, dateStyle: .medium, timeStyle: .short))
                                            .font(.system(size: 11))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 3)
                            }
                        }
                        .padding(18)
                        .background(primaryPale.opacity(0.36))
                        .cornerRadius(14)
                    } else {
                        // Sin boleto
                        VStack(spacing: 12) {
                            Image(systemName: "ticket")
                                .font(.system(size: 36))
                                .foregroundColor(primaryTeal.opacity(0.5))
                            Text("No tienes un boleto registrado.")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(primaryPale.opacity(0.18))
                        .cornerRadius(12)
                    }
                    
                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitle("Mi Perfil", displayMode: .inline)
    }
}

// Componente reutilizable de sección
struct ProfileSectionCard: View {
    let title: String
    let items: [(String, String)]
    let icon: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            ForEach(items, id: \.0) { item in
                HStack {
                    Text(item.0)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .frame(width: 110, alignment: .leading)
                    Text(item.1)
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    ProfileView()
}
