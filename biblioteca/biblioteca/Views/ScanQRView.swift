import SwiftUI
import PhotosUI
import Vision
import CoreImage

// Extensión para convertir UIImage.Orientation a CGImagePropertyOrientation
extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            self = .up
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        print("[DEBUG] Iniciando redimensionamiento de la imagen a tamaño: \(size).")
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let resizedImage = resizedImage {
            print("[DEBUG] Redimensionamiento de la imagen exitoso.")
        } else {
            print("[DEBUG] Error al redimensionar la imagen.")
        }
        return resizedImage ?? self
    }
}

struct ScanQRView: View {
    @State private var isPresentingScanner = false
    @State private var scannedPaintingId: Int?
    @State private var showPaintingDetail = false
    @State private var showErrorAlert = false
    
    @State private var selectedImage: UIImage? // Imagen seleccionada de la galería

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Mostrar la imagen seleccionada (opcional, para depuración visual)
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .border(Color.gray, width: 1)
                        .padding()
                        .onAppear {
                            print("[DEBUG] Imagen seleccionada mostrada en la interfaz.")
                        }
                }
                
                Button(action: {
                    print("[DEBUG] Botón 'Select QR Code from Gallery' pulsado.")
                    isPresentingScanner = true
                }) {
                    Text("Select QR Code from Gallery")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .sheet(isPresented: $isPresentingScanner) {
                    PhotoPickerView(selectedImage: $selectedImage, onImagePicked: handleImage)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Scan QR")
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Invalid QR Code"),
                    message: Text("The selected image does not contain a valid QR code."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(isPresented: $showPaintingDetail) {
                if let paintingId = scannedPaintingId {
                    PaintingDetailView(paintingId: paintingId)
                }
            }
        }
    }
    
    // Maneja la imagen seleccionada desde el PhotoPicker
    func handleImage(_ image: UIImage?) {
        if let image = image {
            print("[DEBUG] Imagen cargada exitosamente.")
            selectedImage = image
            decodeQRCode(from: image)
        } else {
            print("[DEBUG] Falló la carga de la imagen.")
            // Maneja el caso donde no se pudo cargar la imagen
            showErrorAlert = true
        }
    }
    
    // Decodifica el QR code desde la imagen seleccionada usando Vision y, si falla, usa CoreImage
    func decodeQRCode(from image: UIImage) {
        print("[DEBUG] Iniciando proceso de decodificación del QR Code.")
        
        guard let cgImage = image.cgImage else {
            print("[DEBUG] Error: No se encontró un CGImage válido en la imagen seleccionada.")
            showErrorAlert = true
            return
        }
        
        // Convertir la orientación de UIImage a CGImagePropertyOrientation
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        print("[DEBUG] Orientación de la imagen: \(orientation)")
        
        // Usar la imagen original sin redimensionar
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
        
        let request = VNDetectBarcodesRequest { request, error in
            if let error = error {
                print("[DEBUG] Error al detectar el QR Code con Vision: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    // Intentar con CoreImage si Vision falla
                    decodeQRCodeWithCoreImage(from: image)
                }
                return
            }
            
            guard let results = request.results as? [VNBarcodeObservation], !results.isEmpty else {
                print("[DEBUG] No se encontraron QR Codes en la imagen con Vision.")
                DispatchQueue.main.async {
                    // Intentar con CoreImage si Vision no detecta nada
                    decodeQRCodeWithCoreImage(from: image)
                }
                return
            }
            
            print("[DEBUG] Detección de QR Code completada con Vision. Se encontraron \(results.count) QR Code(s).")
            
            // Procesar cada QR code detectado
            for (index, result) in results.enumerated() {
                print("[DEBUG] Procesando QR Code \(index + 1):")
                // Dado que 'symbology' no es opcional, lo accedemos directamente
                print("[DEBUG] Simbología: \(result.symbology.rawValue)")
                
                // Manejar el payload del QR Code
                if let payload = result.payloadStringValue {
                    print("[DEBUG] Payload: '\(payload)'")
                    
                    // Mostrar el tipo de datos del payload
                    print("[DEBUG] Tipo de Payload: \(type(of: payload))")
                    
                    // Validar si el payload es un número entero (ID de la pintura)
                    if let id = Int(payload.trimmingCharacters(in: .whitespacesAndNewlines)) {
                        print("[DEBUG] Payload interpretado como ID de pintura válido: \(id)")
                        DispatchQueue.main.async {
                            scannedPaintingId = id
                            showPaintingDetail = true
                        }
                    } else {
                        print("[DEBUG] El payload no es un ID de pintura válido. Payload: '\(payload)'")
                        DispatchQueue.main.async {
                            showErrorAlert = true
                        }
                    }
                } else {
                    print("[DEBUG] QR Code detectado, pero el payload está vacío.")
                    DispatchQueue.main.async {
                        showErrorAlert = true
                    }
                }
            }
        }
        
        // Configurar la solicitud para detectar solo QR Codes
        request.symbologies = [.QR]
        print("[DEBUG] Solicitud de detección configurada para detectar únicamente QR Codes.")
        
        do {
            print("[DEBUG] Realizando la solicitud de detección de QR Code con Vision...")
            try handler.perform([request])
            print("[DEBUG] Solicitud de detección de QR Code con Vision completada.")
        } catch {
            print("[DEBUG] Error al realizar la solicitud de Vision: \(error.localizedDescription)")
            DispatchQueue.main.async {
                // Intentar con CoreImage si Vision falla
                decodeQRCodeWithCoreImage(from: image)
            }
        }
    }
    
    // Función alternativa para decodificar QR Code usando CoreImage
    func decodeQRCodeWithCoreImage(from image: UIImage) {
        print("[DEBUG] Iniciando proceso de decodificación del QR Code con CoreImage.")
        
        guard let ciImage = CIImage(image: image) else {
            print("[DEBUG] Error: No se pudo convertir UIImage a CIImage.")
            showErrorAlert = true
            return
        }
        
        // Crear el detector de QR Codes
        let context = CIContext()
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options) else {
            print("[DEBUG] Error: No se pudo crear el detector de QR Codes.")
            showErrorAlert = true
            return
        }
        
        // Detectar los QR Codes en la imagen
        let features = detector.features(in: ciImage)
        if features.isEmpty {
            print("[DEBUG] No se encontraron QR Codes en la imagen con CoreImage.")
            showErrorAlert = true
            return
        }
        
        print("[DEBUG] Detección de QR Code con CoreImage completada. Se encontraron \(features.count) QR Code(s).")
        
        for (index, feature) in features.enumerated() {
            if let qrFeature = feature as? CIQRCodeFeature, let payload = qrFeature.messageString {
                print("[DEBUG] Procesando QR Code \(index + 1):")
                print("[DEBUG] Payload: '\(payload)'")
                
                // Mostrar el tipo de datos del payload
                print("[DEBUG] Tipo de Payload: \(type(of: payload))")
                
                // Validar si el payload es un número entero (ID de la pintura)
                if let id = Int(payload.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    print("[DEBUG] Payload interpretado como ID de pintura válido: \(id)")
                    DispatchQueue.main.async {
                        scannedPaintingId = id
                        showPaintingDetail = true
                    }
                } else {
                    print("[DEBUG] El payload no es un ID de pintura válido. Payload: '\(payload)'")
                    DispatchQueue.main.async {
                        showErrorAlert = true
                    }
                }
            } else {
                print("[DEBUG] QR Code detectado, pero el payload está vacío o no es un CIQRCodeFeature.")
                DispatchQueue.main.async {
                    showErrorAlert = true
                }
            }
        }
    }
}

struct PhotoPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onImagePicked: (UIImage?) -> Void // Ahora acepta UIImage? en lugar de UIImage

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // Filtrar solo imágenes
        configuration.selectionLimit = 1 // Limitar a una selección
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        print("[DEBUG] PHPickerViewController creado.")
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPickerView
        
        init(parent: PhotoPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print("[DEBUG] PHPickerViewController 'didFinishPicking' llamado.")
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                print("[DEBUG] No se encontró un proveedor de imágenes adecuado.")
                DispatchQueue.main.async {
                    self.parent.onImagePicked(nil)
                }
                return
            }
            
            provider.loadObject(ofClass: UIImage.self) { object, error in
                if let error = error {
                    print("[DEBUG] Error al cargar la imagen: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.parent.onImagePicked(nil)
                    }
                    return
                }
                
                if let image = object as? UIImage {
                    print("[DEBUG] Imagen cargada exitosamente desde el proveedor.")
                    DispatchQueue.main.async {
                        self.parent.onImagePicked(image)
                    }
                } else {
                    print("[DEBUG] Falló al convertir el objeto cargado a UIImage.")
                    DispatchQueue.main.async {
                        self.parent.onImagePicked(nil)
                    }
                }
            }
        }
    }
}
