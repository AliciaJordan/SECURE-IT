//
//  ImagePicker.swift
//  devTYSV2
//
//  Created by RIcardo Bucio on 10/17/25.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    let sourceType: UIImagePickerController.SourceType
    let onImageSelected: ((UIImage) -> Void)?
    
    init(selectedImage: Binding<UIImage?>, sourceType: UIImagePickerController.SourceType, onImageSelected: ((UIImage) -> Void)? = nil) {
        self._selectedImage = selectedImage
        self.sourceType = sourceType
        self.onImageSelected = onImageSelected
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.onImageSelected?(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ImagePickerSheet: View {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    let title: String
    let onImageSelected: ((UIImage) -> Void)?
    @State private var showingCamera = false
    @State private var showingPhotoLibrary = false
    
    init(selectedImage: Binding<UIImage?>, isPresented: Binding<Bool>, title: String, onImageSelected: ((UIImage) -> Void)? = nil) {
        self._selectedImage = selectedImage
        self._isPresented = isPresented
        self.title = title
        self.onImageSelected = onImageSelected
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
                .padding()
            
            Button("Tomar Foto") {
                showingCamera = true
            }
            .foregroundColor(.blue)
            .sheet(isPresented: $showingCamera) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera, onImageSelected: onImageSelected)
            }
            
            Button("Seleccionar de Galería") {
                showingPhotoLibrary = true
            }
            .foregroundColor(.blue)
            .sheet(isPresented: $showingPhotoLibrary) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary, onImageSelected: onImageSelected)
            }
            
            Button("Cancelar") {
                isPresented = false
            }
            .foregroundColor(.red)
        }
        .padding()
    }
}
