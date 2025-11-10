//
//  UserRegistrationView.swift
//  devTYSV2 - SECURE-IT Redesign
//
//  Vista de registro limpia y moderna

import SwiftUI
import CoreML

struct UserRegistrationView: View {
    @State private var username = ""
    @State private var fullName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var birthYear = ""
    @State private var nationality = ""
    @State private var showRegistrationSuccess = false
    @State private var generatedClientID = ""
    
    // Image states
    @State private var idImage: UIImage?
    @State private var selfieImage: UIImage?
    @State private var ticketImage: UIImage?
    @State private var showingImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var currentImageType: ImageType = .id
    @State private var passportCountryResult: CoreMLManager.PassportCountryResult?
    @State private var isDetectingPassportCountry = false
    @State private var passportOriginLabel: String = ""
    @State private var passportOriginConfidence: Double = 0.0
    @State private var isClassifyingPassportOrigin = false
    
    // 🔙 Dismiss para volver al view anterior
    @Environment(\.dismiss) private var dismiss
    
    // CoreML states
    @StateObject private var coreMLManager = CoreMLManager()
    @State private var idClassification: String = ""
    @State private var classificationConfidence: Double = 0.0
    @State private var isClassifying = false
    
    enum ImageType {
        case id, selfie, ticket
    }
    
    let birthYears = Array(1950...2010).map { String($0) }
    let nationalities = ["México", "Estados Unidos", "Canadá", "Brasil", "Argentina", "España", "Francia", "Alemania", "Italia", "Reino Unido", "Japón", "Corea del Sur", "Australia", "Otro"]
    
    // Paleta de colores
    let primaryDark = Color(hex: "205072")
    let primaryTeal = Color(hex: "329D9C")
    let primaryGreen = Color(hex: "56C596")
    let primaryLight = Color(hex: "7BE495")
    let primaryPale = Color(hex: "CFF4D2")
    
    var body: some View {
        if showRegistrationSuccess {
            RegistrationSuccessView(clientID: generatedClientID)
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [primaryPale.opacity(0.3), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
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
                        
                        Text("Registro")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(primaryDark)
                        
                        Spacer()
                        
                        // Spacer invisible para centrar
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
                    .padding(.bottom, 24)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Hero icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [primaryTeal.opacity(0.2), primaryGreen.opacity(0.2)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.system(size: 48, weight: .semibold))
                                    .foregroundColor(primaryGreen)
                            }
                            .padding(.top, 8)
                            
                            VStack(spacing: 8) {
                                Text("Crea tu cuenta")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(primaryDark)
                                
                                Text("Completa tu información para obtener tu ID de cliente")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
                            .padding(.bottom, 8)
                            
                            // Formulario
                            VStack(spacing: 20) {
                                // Usuario
                                FormField(
                                    label: "Usuario",
                                    placeholder: "juanperez123",
                                    text: $username,
                                    icon: "person.fill"
                                )
                                
                                // Nombre completo
                                FormField(
                                    label: "Nombre Completo",
                                    placeholder: "Juan Pérez García",
                                    text: $fullName,
                                    icon: "person.text.rectangle.fill"
                                )
                                
                                // Teléfono
                                FormField(
                                    label: "Teléfono",
                                    placeholder: "+52 664 123 4567",
                                    text: $phone,
                                    icon: "phone.fill"
                                )
                                
                                // Email
                                FormField(
                                    label: "Correo Electrónico",
                                    placeholder: "correo@ejemplo.com",
                                    text: $email,
                                    icon: "envelope.fill"
                                )
                                
                                // ID/Pasaporte
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "creditcard.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(primaryTeal)
                                        Text("Imagen de ID / Pasaporte")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(primaryDark)
                                    }
                                    
                                    Button(action: {
                                        currentImageType = .id
                                        showingImagePicker = true
                                    }) {
                                        HStack(spacing: 12) {
                                            if isClassifying {
                                                ProgressView()
                                                    .scaleEffect(0.9)
                                            } else {
                                                Image(systemName: idImage != nil ? "checkmark.circle.fill" : "arrow.up.circle.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(idImage != nil ? primaryGreen : .gray)
                                            }
                                            
                                            Text(idImage != nil ? "ID seleccionado" : "Subir imagen de ID")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(idImage != nil ? primaryGreen : .gray)
                                            
                                            Spacer()
                                        }
                                        .frame(height: 52)
                                        .padding(.horizontal, 16)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(idImage != nil ? primaryGreen : Color.gray.opacity(0.3), lineWidth: 1.5)
                                        )
                                    }
                                    .disabled(isClassifying)
                                    
                                    // Resultado de clasificación
                                    if !idClassification.isEmpty && idImage != nil {
                                        HStack(spacing: 10) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(primaryGreen)
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Tipo: \(idClassification)")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(primaryDark)
                                                
                                                Text("Confianza: \(Int(classificationConfidence * 100))%")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(12)
                                        .background(primaryPale.opacity(0.5))
                                        .cornerRadius(10)
                                    }
                                    
                                    if idImage != nil {
                                        if isClassifyingPassportOrigin {
                                            HStack(spacing: 10) {
                                                ProgressView()
                                                    .scaleEffect(0.8)
                                                Text("Clasificando origen del pasaporte...")
                                                    .font(.system(size: 13, weight: .medium))
                                                    .foregroundColor(.gray)
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(primaryPale.opacity(0.3))
                                            .cornerRadius(10)
                                        } else if let passportOriginDisplayText = passportOriginDisplayText {
                                            HStack(spacing: 12) {
                                                Image(systemName: passportOriginLabel == "MEX" ? "flag.fill" : "globe")
                                                    .foregroundColor(passportOriginLabel == "MEX" ? primaryGreen : primaryTeal)
                                                    .font(.system(size: 18))
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text("Clasificación pasaporte: \(passportOriginDisplayText)")
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundColor(primaryDark)
                                                    Text("Confianza: \(Int(passportOriginConfidence * 100))%")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(primaryPale.opacity(0.5))
                                            .cornerRadius(10)
                                        }
                                        
                                        if isDetectingPassportCountry && passportOriginLabel != "MEX" {
                                            HStack(spacing: 10) {
                                                ProgressView()
                                                    .scaleEffect(0.8)
                                                Text("Detectando país del pasaporte...")
                                                    .font(.system(size: 13, weight: .medium))
                                                    .foregroundColor(.gray)
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(primaryPale.opacity(0.3))
                                            .cornerRadius(10)
                                        } else if let passportCountryResult = passportCountryResult, passportCountryResult.isoCode != "MEX" {
                                            HStack(spacing: 12) {
                                                Image(systemName: "globe")
                                                    .foregroundColor(primaryTeal)
                                                    .font(.system(size: 18))
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text("País detectado: \(passportCountryResult.displayName)")
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundColor(primaryDark)
                                                    Text("Código ISO3: \(passportCountryResult.isoCode)")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(primaryPale.opacity(0.5))
                                            .cornerRadius(10)
                                        } else if shouldShowCountryDetectionFailure {
                                            HStack(spacing: 10) {
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundColor(.orange)
                                                    .font(.system(size: 16))
                                                Text("No se pudo detectar el país del pasaporte. Intenta usar una imagen más clara.")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.gray)
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(primaryPale.opacity(0.3))
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                                
                                // Selfie
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(primaryTeal)
                                        Text("Selfie / Foto de Rostro")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(primaryDark)
                                    }
                                    
                                    Button(action: {
                                        currentImageType = .selfie
                                        showingImagePicker = true
                                    }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: selfieImage != nil ? "checkmark.circle.fill" : "camera.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(selfieImage != nil ? primaryGreen : .gray)
                                            
                                            Text(selfieImage != nil ? "Selfie tomada" : "Tomar selfie")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(selfieImage != nil ? primaryGreen : .gray)
                                            
                                            Spacer()
                                        }
                                        .frame(height: 52)
                                        .padding(.horizontal, 16)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selfieImage != nil ? primaryGreen : Color.gray.opacity(0.3), lineWidth: 1.5)
                                        )
                                    }
                                }
                                
                                // Año de nacimiento
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .font(.system(size: 14))
                                            .foregroundColor(primaryTeal)
                                        Text("Año de Nacimiento")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(primaryDark)
                                    }
                                    
                                    Menu {
                                        ForEach(birthYears, id: \.self) { year in
                                            Button(year) {
                                                birthYear = year
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(birthYear.isEmpty ? "Selecciona tu año" : birthYear)
                                                .foregroundColor(birthYear.isEmpty ? .gray : primaryDark)
                                                .font(.system(size: 16))
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(primaryTeal)
                                                .font(.system(size: 14))
                                        }
                                        .frame(height: 52)
                                        .padding(.horizontal, 16)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                                        )
                                    }
                                }
                                
                                // Nacionalidad
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "flag.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(primaryTeal)
                                        Text("Nacionalidad")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(primaryDark)
                                    }
                                    
                                    Menu {
                                        ForEach(nationalities, id: \.self) { nat in
                                            Button(nat) {
                                                nationality = nat
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(nationality.isEmpty ? "Selecciona tu nacionalidad" : nationality)
                                                .foregroundColor(nationality.isEmpty ? .gray : primaryDark)
                                                .font(.system(size: 16))
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(primaryTeal)
                                                .font(.system(size: 14))
                                        }
                                        .frame(height: 52)
                                        .padding(.horizontal, 16)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                                        )
                                    }
                                }
                                
                                // Boleto FIFA
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "ticket.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(primaryTeal)
                                        Text("Foto del Boleto FIFA 2026")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(primaryDark)
                                    }
                                    
                                    Button(action: {
                                        currentImageType = .ticket
                                        showingImagePicker = true
                                    }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: ticketImage != nil ? "checkmark.circle.fill" : "arrow.up.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(ticketImage != nil ? primaryGreen : .gray)
                                            
                                            Text(ticketImage != nil ? "Boleto subido" : "Subir foto del boleto")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(ticketImage != nil ? primaryGreen : .gray)
                                            
                                            Spacer()
                                        }
                                        .frame(height: 52)
                                        .padding(.horizontal, 16)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(ticketImage != nil ? primaryGreen : Color.gray.opacity(0.3), lineWidth: 1.5)
                                        )
                                    }
                                    
                                    Text("Asegúrate de que el código QR y los datos del boleto sean visibles")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            // Info de seguridad
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Image(systemName: "lock.shield.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(primaryTeal)
                                    
                                    Text("Seguridad y Privacidad")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(primaryDark)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    SecurityPoint(text: "Tus datos están protegidos con encriptación")
                                    SecurityPoint(text: "El boleto se vinculará a tu ID de cliente")
                                    SecurityPoint(text: "La verificación de identidad previene fraudes")
                                    SecurityPoint(text: "Solo tú podrás acceder a tus boletos registrados")
                                }
                            }
                            .padding(20)
                            .background(primaryPale.opacity(0.3))
                            .cornerRadius(16)
                            .padding(.horizontal, 24)
                            
                            // Botón registrar
                            Button(action: {
                                generateClientID()
                                showRegistrationSuccess = true
                            }) {
                                Text("Registrar y Obtener ID")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [primaryTeal, primaryGreen]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(28)
                                    .shadow(color: primaryGreen.opacity(0.3), radius: 10, x: 0, y: 4)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePickerSheet(
                    selectedImage: getCurrentImageBinding(),
                    isPresented: $showingImagePicker,
                    title: getImagePickerTitle(),
                    onImageSelected: { image in
                        if currentImageType == .id {
                            classifyIDImage(image)
                        }
                    }
                )
            }
        }
    }
    
    private func getCurrentImageBinding() -> Binding<UIImage?> {
        switch currentImageType {
        case .id: return $idImage
        case .selfie: return $selfieImage
        case .ticket: return $ticketImage
        }
    }
    
    private func getImagePickerTitle() -> String {
        switch currentImageType {
        case .id: return "Seleccionar Imagen de ID"
        case .selfie: return "Tomar Selfie"
        case .ticket: return "Subir Foto del Boleto"
        }
    }
    
    private func generateClientID() {
        let prefix = "FIFA2026-"
        let randomString = generateRandomString(length: 8)
        generatedClientID = prefix + randomString
    }
    
    private func generateRandomString(length: Int) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
    
    private func classifyIDImage(_ image: UIImage) {
        isClassifying = true
        idClassification = ""
        classificationConfidence = 0.0
        passportCountryResult = nil
        isDetectingPassportCountry = true
        passportOriginLabel = ""
        passportOriginConfidence = 0.0
        isClassifyingPassportOrigin = true
        
        coreMLManager.classifyImage(image) { classification, confidence in
            isClassifying = false
            idClassification = classification
            classificationConfidence = confidence
        }
        
        coreMLManager.detectPassportCountry(from: image) { result in
            passportCountryResult = result
            isDetectingPassportCountry = false
        }
        
        coreMLManager.classifyPassportOrigin(image) { label, confidence in
            passportOriginLabel = label
            passportOriginConfidence = confidence
            if label == "MEX" && (passportCountryResult?.isoCode != "MEX") {
                passportCountryResult = CoreMLManager.PassportCountryResult(isoCode: "MEX", displayName: "México")
            }
            isClassifyingPassportOrigin = false
        }
    }
}

private extension UserRegistrationView {
    var passportOriginDisplayText: String? {
        let normalizedLabel = passportOriginLabel.uppercased()
        guard !normalizedLabel.isEmpty else { return nil }
        
        if normalizedLabel == "MEX" {
            return "Mexicano"
        }
        
        if let countryName = passportCountryResult?.displayName, !countryName.isEmpty {
            return "Otro (\(countryName))"
        }
        
        if !isDetectingPassportCountry {
            return "Otro"
        }
        
        return nil
    }
    
    var shouldShowCountryDetectionFailure: Bool {
        let normalizedLabel = passportOriginLabel.uppercased()
        return !isDetectingPassportCountry &&
        !normalizedLabel.isEmpty &&
        normalizedLabel != "MEX" &&
        passportCountryResult == nil
    }
}

// Campo de formulario
struct FormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "329D9C"))
                Text(label)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "205072"))
            }
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                )
        }
    }
}

// Punto de seguridad
struct SecurityPoint: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "56C596"))
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    UserRegistrationView()
}
